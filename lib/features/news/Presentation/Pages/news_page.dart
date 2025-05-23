import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:namhockey/features/news/presentation/bloc/news_bloc.dart';
import 'package:namhockey/features/news/presentation/pages/add_news_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(GetNewsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final appUserState = context.read<AppUserCubit>().state;
    final isAdmin =
        appUserState is AppUserLoggedIn && appUserState.user.role == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        centerTitle: true,
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BlocProvider.value(
                          value: context.read<NewsBloc>(),
                          child: const AddNewsPage(),
                        ),
                  ),
                );
              },
            ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 150, 145, 145),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NewsFailure) {
            return Center(child: Text(state.message));
          }

          if (state is NewsLoaded) {
            return ListView.builder(
              itemCount: state.news.length,
              itemBuilder: (context, index) {
                final news = state.news[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (news.imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                          child: Image.network(
                            news.imageUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(
                                height: 200,
                                child: Center(child: Icon(Icons.error)),
                              );
                            },
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    news.title,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                if (isAdmin)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      print(
                                        'Delete button pressed for news ID: ${news.id}',
                                      );
                                      showDialog(
                                        context: context,
                                        builder:
                                            (dialogContext) => AlertDialog(
                                              title: const Text('Delete News'),
                                              content: const Text(
                                                'Are you sure you want to delete this news?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    print('Delete cancelled');
                                                    Navigator.pop(
                                                      dialogContext,
                                                    );
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    print(
                                                      'Delete confirmed for news ID: ${news.id}',
                                                    );
                                                    context
                                                        .read<NewsBloc>()
                                                        .add(
                                                          DeleteNewsEvent(
                                                            id: news.id,
                                                          ),
                                                        );
                                                    Navigator.pop(
                                                      dialogContext,
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              news.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Published: ${news.publishedAt}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No news available'));
        },
      ),
    );
  }
}
