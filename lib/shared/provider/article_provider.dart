import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:yb_fe_take_home_test/shared/models/article_query.dart';
import '../sources/article_api.dart';
import '../repositories/article_repository.dart';
import '../models/article.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(baseUrl: 'https://gnews-proxy-test.vercel.app/api'));
});

final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  return ArticleRepository(ArticleApi(ref.read(dioProvider)));
});

final articlesProvider = FutureProvider.family<List<Article>, ArticleQuery>((
  ref,
  query,
) async {
  final repo = ref.read(articleRepositoryProvider);
  return repo.getArticles(query, page: query.page, limit: query.limit);
});
