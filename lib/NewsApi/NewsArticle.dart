import 'dart:convert';

class NewsArticle {
  final String sourceName;
  final String author;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String publishedAt;
  final String content;

  NewsArticle({
    required this.sourceName,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    required this.content,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      sourceName: json['source']['name'] as String? ?? '',
      author: json['author'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      url: json['url'] as String? ?? '',
      imageUrl: json['urlToImage'] as String? ?? '',
      publishedAt: json['publishedAt'] as String? ?? '',
      content: json['content'] as String? ?? '',
    );
  }
}

List<NewsArticle> parseNewsData(String newsData) {
  final List<NewsArticle> newsArticles = [];
  final jsonData = json.decode(newsData);

  if (jsonData['articles'] != null) {
    for (final article in jsonData['articles']) {
      final newsArticle = NewsArticle.fromJson(article);
      newsArticles.add(newsArticle);
    }
  }

  return newsArticles;
}
