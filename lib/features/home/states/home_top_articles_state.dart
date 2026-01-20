import 'package:yb_fe_take_home_test/shared/models/article.dart';

class HomeTopArticlesState {
  final List<Article> articles;
  final bool isLoading;
  final bool isError;
  final bool hasMore;
  final int page;

  HomeTopArticlesState({
    required this.articles,
    required this.isLoading,
    required this.isError,
    required this.hasMore,
    required this.page,
  });

  factory HomeTopArticlesState.initial() {
    return HomeTopArticlesState(
      articles: [],
      isLoading: false,
      isError: false,
      hasMore: true,
      page: 1,
    );
  }

  HomeTopArticlesState copyWith({
    List<Article>? articles,
    bool? isLoading,
    bool? isError,
    bool? hasMore,
    int? page,
  }) {
    return HomeTopArticlesState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}
