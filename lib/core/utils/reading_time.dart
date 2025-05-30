class ReadingTimeCalculator {
  static const int _wordsPerMinute = 200; // Average reading speed

  static int calculateReadingTime(String text) {
    if (text.isEmpty) return 1;
    
    final words = text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty);
    final wordCount = words.length;
    
    final minutes = (wordCount / _wordsPerMinute).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  static String formatReadingTime(String text) {
    final minutes = calculateReadingTime(text);
    return '$minutes min read';
  }

  static String formatReadingTimeFromMinutes(int minutes) {
    if (minutes <= 1) {
      return '1 min read';
    }
    return '$minutes min read';
  }

  static int getWordCount(String text) {
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  static String formatWordCount(String text) {
    final count = getWordCount(text);
    return '$count words';
  }
}