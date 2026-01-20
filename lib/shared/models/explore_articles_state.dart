import 'package:yb_fe_take_home_test/shared/models/article.dart';

class ExploreArticlesState {
  final List<Article> articles;
  final bool isLoading;
  final bool hasMore;
  final int page;

  ExploreArticlesState({
    required this.articles,
    required this.isLoading,
    required this.hasMore,
    required this.page,
  });

  factory ExploreArticlesState.initial() {
    return ExploreArticlesState(
      articles: [],
      isLoading: false,
      hasMore: true,
      page: 1,
    );
  }

  ExploreArticlesState copyWith({
    List<Article>? articles,
    bool? isLoading,
    bool? hasMore,
    int? page,
  }) {
    return ExploreArticlesState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}
