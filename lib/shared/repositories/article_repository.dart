import 'package:yb_fe_take_home_test/shared/models/article_query.dart';
import '../models/article.dart';
import '../sources/article_api.dart';

class ArticleRepository {
  ArticleRepository(this.api);

  final ArticleApi api;

  final Map<ArticleQuery, List<Article>> _cache = {};
  final Map<ArticleQuery, DateTime> _lastFetch = {};

  final cacheDuration = const Duration(minutes: 5);

  Future<List<Article>> getArticles(
    ArticleQuery query, {
    required int page,
    int limit = 11,
  }) async {
    final data = await api.fetchArticles(
      query: query,
      page: page,
      limit: limit,
    );

    _cache[query] = data;
    _lastFetch[query] = DateTime.now();

    return data;
  }

  Future<List<Article>> getTopHeadlines(
    ArticleQuery query, {
    required int page,
    int limit = 11,
    String category = 'General',
  }) async {
    final data = await api.fetchTopHeadlines(
      query: query,
      page: page,
      limit: limit
    );

    _cache[query] = data;
    _lastFetch[query] = DateTime.now();

    return data;
  }
}
