import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yb_fe_take_home_test/features/home/states/home_articles_state.dart';
import 'package:yb_fe_take_home_test/shared/models/article_query.dart';
import 'package:yb_fe_take_home_test/shared/repositories/article_repository.dart';

class HomeArticlesNotifier extends StateNotifier<HomeArticlesState> {
  HomeArticlesNotifier(this.repo, this.query)
    : super(HomeArticlesState.initial()) {
    fetchInitial();
  }

  final ArticleRepository repo;
  final ArticleQuery query;

  Future<void> fetchInitial() async {
    state = state.copyWith(isLoading: true);

    final result = await repo.getArticles(query, page: 1);

    state = state.copyWith(
      articles: result,
      page: 2,
      hasMore: result.isNotEmpty,
      isLoading: false,
    );
  }
}
