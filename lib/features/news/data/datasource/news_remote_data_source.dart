import 'dart:io';
import 'package:namhockey/features/news/data/model/news_model.dart';
import 'package:namhockey/features/news/domain/entity/news_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class NewsRemoteDataSource {
  Future<List<NewsEntity>> getNews();
  Future<NewsEntity> addNews({
    required String title,
    required String description,
    required String imageUrl,
    required String publishedAt,
  });
  Future<void> deleteNews(String id);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final SupabaseClient supabaseClient;

  NewsRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<NewsEntity>> getNews() async {
    try {
      print('Fetching news from Supabase...');
      final response = await supabaseClient
          .from('news')
          .select()
          .order('published_at', ascending: false);

      print('News response: $response');

      return (response as List)
          .map((news) => NewsModel.fromJson(news as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching news: $e');
      throw Exception('Failed to get news: $e');
    }
  }

  @override
  Future<NewsEntity> addNews({
    required String title,
    required String description,
    required String imageUrl,
    required String publishedAt,
  }) async {
    try {
      print('Starting to add news...');
      print('Title: $title');
      print('Description: $description');
      print('Image URL: $imageUrl');
      print('Published At: $publishedAt');

      // Check JWT token
      final session = supabaseClient.auth.currentSession;
      print('JWT token: ${session?.accessToken}');
      print('User metadata: ${session?.user.userMetadata}');
      print('User role: ${session?.user.userMetadata?['role']}');

      // Upload the local image file to Supabase storage
      final imageFile = File(imageUrl);
      print('Reading image file from: ${imageFile.path}');
      final imageBytes = await imageFile.readAsBytes();
      print('Image file read successfully');

      final imagePath = 'news/${DateTime.now().millisecondsSinceEpoch}.jpg';
      print('Uploading image to path: $imagePath');
      await supabaseClient.storage
          .from('news')
          .uploadBinary(imagePath, imageBytes);
      print('Image uploaded successfully');

      // Get the public URL of the uploaded image
      final imagePublicUrl = supabaseClient.storage
          .from('news')
          .getPublicUrl(imagePath);
      print('Image public URL: $imagePublicUrl');

      // Insert the news with the image URL
      print('Inserting news into database...');
      final response =
          await supabaseClient
              .from('news')
              .insert({
                'title': title,
                'description': description,
                'image': imagePublicUrl,
                'published_at': publishedAt,
              })
              .select()
              .single();
      print('News inserted successfully: $response');

      return NewsModel.fromJson(response);
    } catch (e) {
      print('Error adding news: $e');
      throw Exception('Failed to add news: $e');
    }
  }

  @override
  Future<void> deleteNews(String id) async {
    try {
      print('Deleting news with ID: $id');
      final session = supabaseClient.auth.currentSession;
      print('Current session: ${session?.accessToken}');
      print('User role: ${session?.user.userMetadata?['role']}');

      if (session == null) {
        throw Exception('No active session');
      }

      // First verify the news exists
      final news =
          await supabaseClient.from('news').select().eq('id', id).single();

      // Then delete it with explicit error handling
      try {
        final response =
            await supabaseClient.from('news').delete().eq('id', id).select();

        print('Delete response: $response');

        // Verify deletion by trying to fetch the news again
        final verifyNews =
            await supabaseClient
                .from('news')
                .select()
                .eq('id', id)
                .maybeSingle();

        if (verifyNews != null) {
          throw Exception('News still exists after deletion');
        }

        print('News deleted successfully');
      } catch (e) {
        print('Error during delete operation: $e');
        throw Exception('Failed to delete news: $e');
      }
    } catch (e) {
      print('Error deleting news: $e');
      throw Exception('Failed to delete news: $e');
    }
  }
}
