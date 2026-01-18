// services/news_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ArticlesServices {
  static const String baseUrl = 'https://gnews-proxy-test.vercel.app/api';

  Future<List<Article>> fetchArticles(String query, String max) async {
    final url = Uri.parse('$baseUrl/search?max=$max&q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articlesJson = data['articles'];
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<List<Article>> fetchTopArticles(String category) async {
    final url = Uri.parse(
      '$baseUrl/top-headlines?max=5&category=$category',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articlesJson = data['articles'];
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
