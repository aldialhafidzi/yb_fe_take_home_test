import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yb_fe_take_home_test/shared/models/article_query.dart';
import 'package:yb_fe_take_home_test/features/explore/states/explore_articles_state.dart';
import 'package:yb_fe_take_home_test/shared/repositories/article_repository.dart';

class ExploreArticlesNotifier extends StateNotifier<ExploreArticlesState> {
  ExploreArticlesNotifier(this.repo, this.query)
    : super(ExploreArticlesState.initial()) {
    fetchInitial();
  }

  final ArticleRepository repo;
  final ArticleQuery query;

  Future<void> fetchInitial() async {
    try {
      state = state.copyWith(isLoading: true);

      final result = await repo.getArticles(query, page: 1);

      state = state.copyWith(
        articles: result,
        page: 1,
        hasMore: result.isNotEmpty,
        isError: false,
      );
    } catch (e) {
      state = state.copyWith(isError: true);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadMore() async {
    try {
      if (state.isLoading || !state.hasMore) return;

      state = state.copyWith(isLoading: true);

      final result = await repo.getArticles(query, page: state.page + 1);

      state = state.copyWith(
        articles: [...state.articles, ...result],
        page: state.page + 1,
        hasMore: result.isNotEmpty,
        isError: false,
      );
    } catch (e) {
      state = state.copyWith(isError: true);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
