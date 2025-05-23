import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/core/usecase/usecase.dart';
import 'package:namhockey/features/news/domain/entity/news_entity.dart';
import 'package:namhockey/features/news/domain/usecase/add_news_usecase.dart';
import 'package:namhockey/features/news/domain/usecase/delete_news_usecase.dart';
import 'package:namhockey/features/news/domain/usecase/get_news_usecase.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNewsUseCase _getNewsUseCase;
  final AddNewsUseCase _addNewsUseCase;
  final DeleteNewsUseCase _deleteNewsUseCase;

  NewsBloc({
    required GetNewsUseCase getNewsUseCase,
    required AddNewsUseCase addNewsUseCase,
    required DeleteNewsUseCase deleteNewsUseCase,
  })  : _getNewsUseCase = getNewsUseCase,
        _addNewsUseCase = addNewsUseCase,
        _deleteNewsUseCase = deleteNewsUseCase,
        super(NewsInitial()) {
    on<GetNewsEvent>(_onGetNews);
    on<AddNewsEvent>(_onAddNews);
    on<DeleteNewsEvent>(_onDeleteNews);
  }

  void _onGetNews(GetNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    final res = await _getNewsUseCase(NoParams());
    
    res.fold(
      (l) => emit(NewsFailure(l.message)),
      (r) => emit(NewsLoaded(r)),
    );
  }

  void _onAddNews(AddNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    final res = await _addNewsUseCase(AddNewsParams(
      title: event.title,
      description: event.description,
      imageUrl: event.imageUrl,
      publishedAt: event.publishedAt,
    ));
    
    res.fold(
      (l) => emit(NewsFailure(l.message)),
      (r) => emit(NewsLoaded([r])),
    );
  }

  void _onDeleteNews(DeleteNewsEvent event, Emitter<NewsState> emit) async {
    print('Delete news event received for ID: ${event.id}');
    emit(NewsLoading());
    final res = await _deleteNewsUseCase(DeleteNewsParams(id: event.id));
    
    await res.fold(
      (l) async {
        print('Delete news failed: ${l.message}');
        emit(NewsFailure(l.message));
      },
      (r) async {
        print('Delete news successful');
        // After successful deletion, fetch the updated news list
        final newsRes = await _getNewsUseCase(NoParams());
        await newsRes.fold(
          (l) async => emit(NewsFailure(l.message)),
          (r) async => emit(NewsLoaded(r)),
        );
      },
    );
  }
} 