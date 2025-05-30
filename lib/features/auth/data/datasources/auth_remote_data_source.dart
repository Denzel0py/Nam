import 'package:namhockey/core/common/entities/user_entity.dart';
import 'package:namhockey/core/error/server_exeption.dart';
import 'package:namhockey/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'dart:math';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String role,
  });
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();

  // New methods for user management
  Future<List<UserEntity>> getAllUsers();
  Future<UserEntity> makeCoach({
    required String userId,
    required String teamName,
    required String teamLogoPath,
  });
  Future<UserEntity> makePlayer({
    required String userId,
    required String teamId,
  });
  Future<UserEntity> makeRegularUser({required String userId});
  Future<UserEntity> updateProfile({
    String? name,
    String? email,
    String? profilePicturePath,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name, 'role': role},
      );

      if (response.user == null) {
        throw ServerException('User is null');
      }

      // Create profile with role
      await supabaseClient.from('profiles').insert({
        'id': response.user!.id,
        'name': name,
        'email': email,
        'role': role,
      });

      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      if (currentUserSession != null) {
        final userData =
            await supabaseClient
                .from('profiles')
                .select()
                .eq('id', currentUserSession!.user.id)
                .single();
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );

      if (response.user == null) {
        throw ServerException('User is null');
      }

      // Fetch user profile with role
      final userData =
          await supabaseClient
              .from('profiles')
              .select()
              .eq('id', response.user!.id)
              .single();

      return UserModel.fromJson(userData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<UserEntity>> getAllUsers() async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select()
          .order('name');

      return response.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserEntity> makeCoach({
    required String userId,
    required String teamName,
    required String teamLogoPath,
  }) async {
    try {
      print('Starting makeCoach process...');
      print(
        'Parameters: userId=$userId, teamName=$teamName, teamLogoPath=$teamLogoPath',
      );

      // 1. Verify user exists
      print('Verifying user exists...');
      final userCheck =
          await supabaseClient
              .from('profiles')
              .select()
              .eq('id', userId)
              .maybeSingle();

      if (userCheck == null) {
        throw ServerException('User not found in profiles table');
      }
      print('User found: ${userCheck.toString()}');

      // 2. Upload team logo to storage
      print('Uploading team logo...');
      final file = File(teamLogoPath);
      final fileExt = teamLogoPath.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'team_logos/$fileName';

      final uploadResponse = await supabaseClient.storage
          .from('team_logos')
          .upload(filePath, file);

      if (uploadResponse.isEmpty) {
        throw ServerException('Failed to upload team logo');
      }

      // Get the public URL for the uploaded image
      final imageUrl = supabaseClient.storage
          .from('team_logos')
          .getPublicUrl(filePath);

      print('Team logo uploaded successfully: $imageUrl');

      // 3. Create team with the public URL
      print('Creating team...');
      final teamResponse =
          await supabaseClient
              .from('teams')
              .insert({
                'name': teamName,
                'logo_url': imageUrl,
                'coach_id': userId,
                'created_at': DateTime.now().toIso8601String(),
              })
              .select()
              .single();
      print('Team created successfully: ${teamResponse.toString()}');

      // 4. Add team_id column if it doesn't exist
      print('Checking team_id column...');
      await supabaseClient.rpc('add_team_id_column_if_not_exists');
      print('Team_id column check completed');

      // 5. Update user role and team_id using RPC
      print('Updating user profile...');
      try {
        final updateResponse = await supabaseClient.rpc(
          'update_user_to_coach',
          params: {'user_id': userId, 'p_team_id': teamResponse['id']},
        );
        print('Update response: $updateResponse');
      } catch (e) {
        print('Error during update: $e');
        throw ServerException('Failed to update user profile: $e');
      }

      // 6. Get and return the updated user
      print('Fetching updated user...');
      final updatedUser =
          await supabaseClient
              .from('profiles')
              .select()
              .eq('id', userId)
              .single();
      print('Updated user data: ${updatedUser.toString()}');

      if (updatedUser['role'] != 'coach') {
        print(
          'Role update verification failed. Current role: ${updatedUser['role']}',
        );
        throw ServerException('Failed to update user role to coach');
      }

      return UserModel.fromJson(updatedUser);
    } catch (e) {
      print('Error in makeCoach: $e');
      if (e is PostgrestException) {
        print('PostgreSQL Error Details:');
        print('Code: ${e.code}');
        print('Message: ${e.message}');
        print('Details: ${e.details}');
        print('Hint: ${e.hint}');
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserEntity> makePlayer({
    required String userId,
    required String teamId,
  }) async {
    try {
      print('Starting makePlayer process...');
      print('Parameters: userId=$userId, teamId=$teamId');

      // 1. Verify user exists and is not an admin
      print('Verifying user exists...');
      final userCheck =
          await supabaseClient
              .from('profiles')
              .select()
              .eq('id', userId)
              .maybeSingle();

      if (userCheck == null) {
        throw ServerException('User not found in profiles table');
      }

      if (userCheck['role'] == 'admin') {
        throw ServerException('Cannot change admin role');
      }

      print('User found: ${userCheck.toString()}');

      // 2. Verify team exists and current user is the coach
      print('Verifying team and coach...');
      try {
        final teamCheck =
            await supabaseClient
                .from('teams')
                .select()
                .eq('id', teamId)
                .maybeSingle();

        print('Team check result: ${teamCheck?.toString()}');

        if (teamCheck == null) {
          throw ServerException('Team not found');
        }

        final currentUser = await getCurrentUser();
        print('Current user: ${currentUser?.toString()}');

        if (currentUser == null) {
          throw ServerException('You must be logged in to add players');
        }

        print(
          'Comparing coach IDs: current=${currentUser.id}, team=${teamCheck['coach_id']}',
        );
        if (currentUser.id != teamCheck['coach_id']) {
          throw ServerException(
            'You are not the coach of this team. Only the team coach can add players.',
          );
        }
      } catch (e) {
        print('Error during team/coach verification: $e');
        if (e is PostgrestException) {
          print('PostgreSQL Error Details:');
          print('Code: ${e.code}');
          print('Message: ${e.message}');
          print('Details: ${e.details}');
          print('Hint: ${e.hint}');
        }
        rethrow;
      }

      // 3. Update user role and team_id
      print('Updating user profile...');
      try {
        // First verify the user exists again
        final verifyUser =
            await supabaseClient
                .from('profiles')
                .select()
                .eq('id', userId)
                .single();
        print('Verifying user before update: ${verifyUser.toString()}');

        // Update the user using RPC
        final updateResponse = await supabaseClient.rpc(
          'update_user_to_player',
          params: {'user_id': userId, 'p_team_id': teamId},
        );
        print('Update response: $updateResponse');

        // Then fetch the updated user
        final updatedUser =
            await supabaseClient
                .from('profiles')
                .select()
                .eq('id', userId)
                .single();

        print('Updated user data: ${updatedUser.toString()}');

        if (updatedUser['role'] != 'player') {
          print(
            'Role update verification failed. Current role: ${updatedUser['role']}',
          );
          throw ServerException('Failed to update user role to player');
        }

        return UserModel.fromJson(updatedUser);
      } catch (e) {
        print('Error during user update: $e');
        if (e is PostgrestException) {
          print('PostgreSQL Error Details:');
          print('Code: ${e.code}');
          print('Message: ${e.message}');
          print('Details: ${e.details}');
          print('Hint: ${e.hint}');
        }
        throw ServerException('Failed to update user: ${e.toString()}');
      }
    } catch (e) {
      print('Error in makePlayer: $e');
      if (e is PostgrestException) {
        print('PostgreSQL Error Details:');
        print('Code: ${e.code}');
        print('Message: ${e.message}');
        print('Details: ${e.details}');
        print('Hint: ${e.hint}');
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserEntity> makeRegularUser({required String userId}) async {
    try {
      print('Starting makeRegularUser process...');
      print('Parameters: userId=$userId');

      // 1. Verify user exists and is a player
      print('Verifying user exists...');
      try {
        final userCheck =
            await supabaseClient
                .from('profiles')
                .select()
                .eq('id', userId)
                .maybeSingle();

        print('User check result: ${userCheck?.toString()}');

        if (userCheck == null) {
          print('User not found in profiles table for ID: $userId');
          throw ServerException('User not found in profiles table');
        }

        if (userCheck['role'] != 'player') {
          print(
            'User role check failed. Expected: player, Got: ${userCheck['role']}',
          );
          throw ServerException('User is not a player');
        }

        print('User found: ${userCheck.toString()}');

        // 2. Update user role and remove team_id
        print('Updating user profile...');
        try {
          final updateResponse = await supabaseClient.rpc(
            'update_user_to_regular',
            params: {'user_id': userId},
          );
          print('Update response: $updateResponse');

          // Then fetch the updated user
          final updatedUser =
              await supabaseClient
                  .from('profiles')
                  .select()
                  .eq('id', userId)
                  .single();

          print('Updated user data: ${updatedUser.toString()}');

          if (updatedUser['role'] != 'user') {
            print(
              'Role update verification failed. Expected: user, Got: ${updatedUser['role']}',
            );
            throw ServerException('Failed to update user role to regular user');
          }

          return UserModel.fromJson(updatedUser);
        } catch (e) {
          print('Error during user update: $e');
          if (e is PostgrestException) {
            print('PostgreSQL Error Details:');
            print('Code: ${e.code}');
            print('Message: ${e.message}');
            print('Details: ${e.details}');
            print('Hint: ${e.hint}');
          }
          throw ServerException('Failed to update user: ${e.toString()}');
        }
      } catch (e) {
        print('Error during user verification: $e');
        if (e is PostgrestException) {
          print('PostgreSQL Error Details:');
          print('Code: ${e.code}');
          print('Message: ${e.message}');
          print('Details: ${e.details}');
          print('Hint: ${e.hint}');
        }
        rethrow;
      }
    } catch (e) {
      print('Error in makeRegularUser: $e');
      if (e is PostgrestException) {
        print('PostgreSQL Error Details:');
        print('Code: ${e.code}');
        print('Message: ${e.message}');
        print('Details: ${e.details}');
        print('Hint: ${e.hint}');
      }
      throw ServerException(e.toString());
    }
  }

  Future<String> _uploadProfilePicture(
    String userId,
    String filePath, {
    int maxRetries = 3,
  }) async {
    int retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        print(
          'Attempting to upload profile picture (attempt ${retryCount + 1}/$maxRetries)',
        );
        final file = File(filePath);
        final fileExt = filePath.split('.').last;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
        final storagePath = '${userId}/$fileName';

        // Check if file exists and is readable
        if (!await file.exists()) {
          throw ServerException('Profile picture file not found');
        }

        // Get file size
        final fileSize = await file.length();
        if (fileSize > 5 * 1024 * 1024) {
          // 5MB limit
          throw ServerException('Profile picture size exceeds 5MB limit');
        }

        final uploadResponse = await supabaseClient.storage
            .from('profile_pictures')
            .upload(storagePath, file);

        if (uploadResponse.isEmpty) {
          throw ServerException('Failed to upload profile picture');
        }

        // Get the public URL for the uploaded image
        final imageUrl = supabaseClient.storage
            .from('profile_pictures')
            .getPublicUrl(storagePath);

        print('Profile picture uploaded successfully: $imageUrl');
        return imageUrl;
      } catch (e) {
        retryCount++;
        print('Upload attempt $retryCount failed: $e');

        if (retryCount == maxRetries) {
          throw ServerException(
            'Failed to upload profile picture after $maxRetries attempts: $e',
          );
        }

        // Wait before retrying (exponential backoff)
        await Future.delayed(Duration(seconds: pow(2, retryCount).toInt()));
      }
    }
    throw ServerException('Failed to upload profile picture');
  }

  @override
  Future<UserEntity> updateProfile({
    String? name,
    String? email,
    String? profilePicturePath,
  }) async {
    try {
      print('Starting updateProfile process...');
      print(
        'Parameters: name=$name, email=$email, profilePicturePath=$profilePicturePath',
      );

      if (currentUserSession == null) {
        throw ServerException('No user is currently logged in');
      }

      final userId = currentUserSession!.user.id;
      Map<String, dynamic> updateData = {};

      // Handle profile picture upload if provided
      if (profilePicturePath != null) {
        try {
          final imageUrl = await _uploadProfilePicture(
            userId,
            profilePicturePath,
          );
          updateData['profile_picture_url'] = imageUrl;
        } catch (e) {
          print('Error uploading profile picture: $e');
          // Continue with other updates even if picture upload fails
        }
      }

      // Add name and email to update data if provided
      if (name != null) updateData['name'] = name;
      if (email != null) updateData['email'] = email;

      // If there's nothing to update, return current user
      if (updateData.isEmpty) {
        print('No updates provided, returning current user');
        final currentUser = await getCurrentUser();
        if (currentUser == null) {
          throw ServerException('User not found');
        }
        return currentUser;
      }

      // Update the profile
      print('Updating profile with data: $updateData');
      final response =
          await supabaseClient
              .from('profiles')
              .update(updateData)
              .eq('id', userId)
              .select()
              .single();

      print('Profile updated successfully: ${response.toString()}');
      return UserModel.fromJson(response);
    } catch (e) {
      print('Error in updateProfile: $e');
      if (e is PostgrestException) {
        print('PostgreSQL Error Details:');
        print('Code: ${e.code}');
        print('Message: ${e.message}');
        print('Details: ${e.details}');
        print('Hint: ${e.hint}');
      }
      throw ServerException(e.toString());
    }
  }
}
