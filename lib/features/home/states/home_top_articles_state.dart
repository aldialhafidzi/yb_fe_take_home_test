import 'package:yb_fe_take_home_test/shared/models/article.dart';

class HomeTopArticlesState {
  final List<Article> articles;
  final bool isLoading;
  final bool hasMore;
  final int page;

  HomeTopArticlesState({
    required this.articles,
    required this.isLoading,
    required this.hasMore,
    required this.page,
  });

  factory HomeTopArticlesState.initial() {
    return HomeTopArticlesState(
      articles: [],
      isLoading: false,
      hasMore: true,
      page: 1,
    );
  }

  HomeTopArticlesState copyWith({
    List<Article>? articles,
    bool? isLoading,
    bool? hasMore,
    int? page,
  }) {
    return HomeTopArticlesState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}
