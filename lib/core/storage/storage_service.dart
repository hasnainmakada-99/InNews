import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/models/news_article.dart';
import '../constants/app_constants.dart';

class StorageService {
  static late Box<NewsArticle> _articlesBox;
  static late Box<NewsArticle> _bookmarksBox;
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(NewsArticleAdapter());
    Hive.registerAdapter(SourceAdapter());
    
    // Open boxes
    _articlesBox = await Hive.openBox<NewsArticle>('articles');
    _bookmarksBox = await Hive.openBox<NewsArticle>('bookmarks');
    
    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();
  }

  // Articles Cache
  static Future<void> cacheArticles(String key, List<NewsArticle> articles) async {
    await _articlesBox.clear();
    for (int i = 0; i < articles.length; i++) {
      await _articlesBox.put('${key}_$i', articles[i]);
    }
    await _prefs.setString('${key}_timestamp', DateTime.now().toIso8601String());
  }

  static List<NewsArticle> getCachedArticles(String key) {
    final articles = <NewsArticle>[];
    final keys = _articlesBox.keys.where((k) => k.toString().startsWith(key));
    
    for (final key in keys) {
      final article = _articlesBox.get(key);
      if (article != null) {
        articles.add(article);
      }
    }
    
    return articles;
  }

  static bool isCacheValid(String key) {
    final timestampString = _prefs.getString('${key}_timestamp');
    if (timestampString == null) return false;
    
    final timestamp = DateTime.parse(timestampString);
    final now = DateTime.now();
    final difference = now.difference(timestamp).inSeconds;
    
    return difference < AppConstants.maxCacheAge;
  }

  // Bookmarks
  static Future<void> addBookmark(NewsArticle article) async {
    article.isBookmarked = true;
    await _bookmarksBox.put(article.url, article);
  }

  static Future<void> removeBookmark(String url) async {
    await _bookmarksBox.delete(url);
  }

  static List<NewsArticle> getBookmarks() {
    return _bookmarksBox.values.toList();
  }

  static bool isBookmarked(String url) {
    return _bookmarksBox.containsKey(url);
  }

  // Settings
  static Future<void> setThemeMode(String mode) async {
    await _prefs.setString(AppConstants.themeKey, mode);
  }

  static String getThemeMode() {
    return _prefs.getString(AppConstants.themeKey) ?? 'system';
  }

  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  // Clear all data
  static Future<void> clearAll() async {
    await _articlesBox.clear();
    await _bookmarksBox.clear();
    await _prefs.clear();
  }
}