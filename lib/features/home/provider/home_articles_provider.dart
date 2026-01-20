import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yb_fe_take_home_test/features/home/provider/home_articles_notifier.dart';
import 'package:yb_fe_take_home_test/features/home/states/home_articles_state.dart';
import 'package:yb_fe_take_home_test/features/home/provider/home_top_articles_notifier.dart';
import 'package:yb_fe_take_home_test/features/home/states/home_top_articles_state.dart';
import 'package:yb_fe_take_home_test/shared/models/article_query.dart';
import 'package:yb_fe_take_home_test/shared/provider/article_provider.dart';

final homeArticlesProvider =
    StateNotifierProvider.family<
      HomeArticlesNotifier,
      HomeArticlesState,
      ArticleQuery
    >((ref, query) {
      final repo = ref.read(articleRepositoryProvider);
      return HomeArticlesNotifier(repo, query);
    });

final homeTopArticlesProvider =
    StateNotifierProvider.family<
      HomeTopArticlesNotifier,
      HomeTopArticlesState,
      ArticleQuery
    >((ref, query) {
      final repo = ref.read(topArticleRepositoryProvider);
      return HomeTopArticlesNotifier(repo, query);
    });
