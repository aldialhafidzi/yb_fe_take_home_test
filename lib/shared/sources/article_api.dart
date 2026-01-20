import 'package:dio/dio.dart';
import 'package:yb_fe_take_home_test/shared/models/article_query.dart';
import '../models/article.dart';

class ArticleApi {
  final Dio dio;

  ArticleApi(this.dio);

  Future<List<Article>> fetchArticles({
    required ArticleQuery query,
    required int page,
    required int limit,
  }) async {
    final res = await dio.get(
      '/search',
      queryParameters: {...query.toMap(), 'page': page, 'limit': limit},
    );

    return (res.data['articles'] as List)
        .map((e) => Article.fromJson(e))
        .toList();
  }
}
