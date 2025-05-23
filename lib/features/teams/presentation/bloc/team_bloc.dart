import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/features/teams/domain/usecase/get_team_name_usecase.dart';

// Events
abstract class TeamEvent {}

class GetTeamNameEvent extends TeamEvent {
  final String teamId;
  GetTeamNameEvent(this.teamId);
}

// States
abstract class TeamState {}

class TeamInitial extends TeamState {}

class TeamLoading extends TeamState {}

class TeamLoaded extends TeamState {
  final String teamName;
  TeamLoaded(this.teamName);
}

class TeamError extends TeamState {
  final String message;
  TeamError(this.message);
}

// BLoC
class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final GetTeamNameUseCase getTeamNameUseCase;

  TeamBloc({required this.getTeamNameUseCase}) : super(TeamInitial()) {
    on<GetTeamNameEvent>((event, emit) async {
      emit(TeamLoading());
      try {
        final teamName = await getTeamNameUseCase(event.teamId);
        emit(TeamLoaded(teamName));
      } catch (e) {
        emit(TeamError(e.toString()));
      }
    });
  }
} 