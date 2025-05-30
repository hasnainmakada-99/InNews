// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_article.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewsArticleAdapter extends TypeAdapter<NewsArticle> {
  @override
  final int typeId = 0;

  @override
  NewsArticle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewsArticle(
      source: fields[0] as Source?,
      author: fields[1] as String?,
      title: fields[2] as String,
      description: fields[3] as String?,
      url: fields[4] as String,
      imageUrl: fields[5] as String?,
      publishedAt: fields[6] as DateTime,
      content: fields[7] as String?,
      isBookmarked: fields[8] as bool,
      isRead: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NewsArticle obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.source)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.publishedAt)
      ..writeByte(7)
      ..write(obj.content)
      ..writeByte(8)
      ..write(obj.isBookmarked)
      ..writeByte(9)
      ..write(obj.isRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SourceAdapter extends TypeAdapter<Source> {
  @override
  final int typeId = 1;

  @override
  Source read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Source(
      id: fields[0] as String?,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Source obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsArticle _$NewsArticleFromJson(Map<String, dynamic> json) => NewsArticle(
      source: json['source'] == null
          ? null
          : Source.fromJson(json['source'] as Map<String, dynamic>),
      author: json['author'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      url: json['url'] as String,
      imageUrl: json['urlToImage'] as String?,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      content: json['content'] as String?,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$NewsArticleToJson(NewsArticle instance) =>
    <String, dynamic>{
      'source': instance.source,
      'author': instance.author,
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'urlToImage': instance.imageUrl,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'content': instance.content,
      'isBookmarked': instance.isBookmarked,
      'isRead': instance.isRead,
    };

Source _$SourceFromJson(Map<String, dynamic> json) => Source(
      id: json['id'] as String?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$SourceToJson(Source instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };