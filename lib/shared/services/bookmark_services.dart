import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';

class BookmarkService {
  static const String keyBookmarks = 'bookmarks';

  /// Simpan artikel ke local storage
  static Future<void> addBookmark(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> bookmarks = prefs.getStringList(keyBookmarks) ?? [];

    // Simpan article sebagai JSON string
    final String articleJson = jsonEncode(article.toJson());

    // Cek duplikat
    if (!bookmarks.contains(articleJson)) {
      bookmarks.add(articleJson);
      await prefs.setStringList(keyBookmarks, bookmarks);
    }
  }

  /// Hapus artikel dari bookmark
  static Future<void> removeBookmark(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> bookmarks = prefs.getStringList(keyBookmarks) ?? [];

    bookmarks.removeWhere((e) => e == jsonEncode(article.toJson()));
    await prefs.setStringList(keyBookmarks, bookmarks);
  }

  /// Ambil semua bookmark
  static Future<List<Article>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> bookmarks = prefs.getStringList(keyBookmarks) ?? [];
    return bookmarks.map((e) => Article.fromJson(jsonDecode(e))).toList();
  }
}
