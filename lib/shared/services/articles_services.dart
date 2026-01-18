// services/news_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ArticlesServices {
  static const String apiKey = 'ecab2a5d54bed16048ed4f5b8ca57506';
  // static const String apiKey = '3c47279cd5c0b54f35a53bc5ae0cbe69';
  static const String baseUrl = 'https://gnews.io/api/v4';

  Future<List<Article>> fetchArticles(String query, String max) async {
    final url = Uri.parse('$baseUrl/search?max=$max&q=$query&lang=en&apikey=$apiKey');
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
      '$baseUrl/top-headlines?max=5&category=$category&lang=en&apikey=$apiKey',
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
