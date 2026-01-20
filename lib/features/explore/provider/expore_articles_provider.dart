import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yb_fe_take_home_test/shared/models/article_query.dart';
import 'package:yb_fe_take_home_test/features/explore/states/explore_articles_state.dart';
import 'package:yb_fe_take_home_test/shared/provider/article_provider.dart';
import 'package:yb_fe_take_home_test/features/explore/provider/explore_articles_notifier.dart';

final exploreArticlesProvider =
    StateNotifierProvider.family<
      ExploreArticlesNotifier,
      ExploreArticlesState,
      ArticleQuery
    >((ref, query) {
      final repo = ref.read(articleRepositoryProvider);
      return ExploreArticlesNotifier(repo, query);
    });
