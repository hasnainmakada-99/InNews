class AppConstants {
  // App Info
  static const String appName = 'InNews';
  static const String appVersion = '2.0.0';
  static const String appDescription = 'Your personalized news companion';
  
  // API
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey = 'YOUR_API_KEY_HERE'; // Replace with actual API key
  
  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String bookmarksKey = 'bookmarks';
  static const String settingsKey = 'settings';
  
  // Categories
  static const List<String> newsCategories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];
  
  // Countries
  static const Map<String, String> countries = {
    'us': 'United States',
    'gb': 'United Kingdom',
    'ca': 'Canada',
    'au': 'Australia',
    'in': 'India',
    'de': 'Germany',
    'fr': 'France',
    'jp': 'Japan',
  };
  
  // Pagination
  static const int pageSize = 20;
  static const int maxCacheAge = 300; // 5 minutes in seconds
  
  // UI
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
}