import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'news_article.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class NewsArticle extends HiveObject {
  @HiveField(0)
  final Source? source;

  @HiveField(1)
  final String? author;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final String url;

  @HiveField(5)
  @JsonKey(name: 'urlToImage')
  final String? imageUrl;

  @HiveField(6)
  final DateTime publishedAt;

  @HiveField(7)
  final String? content;

  @HiveField(8)
  bool isBookmarked;

  @HiveField(9)
  bool isRead;

  NewsArticle({
    this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.imageUrl,
    required this.publishedAt,
    this.content,
    this.isBookmarked = false,
    this.isRead = false,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) =>
      _$NewsArticleFromJson(json);

  Map<String, dynamic> toJson() => _$NewsArticleToJson(this);

  NewsArticle copyWith({
    Source? source,
    String? author,
    String? title,
    String? description,
    String? url,
    String? imageUrl,
    DateTime? publishedAt,
    String? content,
    bool? isBookmarked,
    bool? isRead,
  }) {
    return NewsArticle(
      source: source ?? this.source,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isRead: isRead ?? this.isRead,
    );
  }

  String get readingTime {
    if (content == null || content!.isEmpty) return '1 min read';
    
    final wordCount = content!.split(' ').length;
    final minutes = (wordCount / 200).ceil(); // Average reading speed: 200 words/min
    return '$minutes min read';
  }

  String get cleanContent {
    if (content == null) return description ?? '';
    return content!.replaceAll(RegExp(r'\[\+\d+ chars\]$'), '');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsArticle &&
          runtimeType == other.runtimeType &&
          url == other.url;

  @override
  int get hashCode => url.hashCode;
}

@JsonSerializable()
@HiveType(typeId: 1)
class Source extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String name;

  Source({
    this.id,
    required this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);

  Map<String, dynamic> toJson() => _$SourceToJson(this);
}