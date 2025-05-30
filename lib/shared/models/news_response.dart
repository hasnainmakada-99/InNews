import 'package:json_annotation/json_annotation.dart';
import 'news_article.dart';

part 'news_response.g.dart';

@JsonSerializable()
class NewsResponse {
  final String status;
  final int totalResults;
  final List<NewsArticle> articles;
  final String? code;
  final String? message;

  NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
    this.code,
    this.message,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NewsResponseToJson(this);

  bool get isSuccess => status == 'ok';
  bool get hasError => code != null || message != null;
}