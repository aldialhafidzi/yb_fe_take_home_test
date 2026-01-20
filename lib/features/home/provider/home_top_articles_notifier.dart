import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yb_fe_take_home_test/features/home/states/home_top_articles_state.dart';
import 'package:yb_fe_take_home_test/shared/models/article_query.dart';
import 'package:yb_fe_take_home_test/shared/repositories/article_repository.dart';

class HomeTopArticlesNotifier extends StateNotifier<HomeTopArticlesState> {
  HomeTopArticlesNotifier(this.repo, this.query)
    : super(HomeTopArticlesState.initial()) {
    fetchInitial();
  }

  final ArticleRepository repo;
  final ArticleQuery query;

  Future<void> fetchInitial() async {
    state = state.copyWith(isLoading: true);

    final result = await repo.getTopHeadlines(query, page: 1);

    state = state.copyWith(
      articles: result,
      page: 2,
      hasMore: result.isNotEmpty,
      isLoading: false,
    );
  }
}
