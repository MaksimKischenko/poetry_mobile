// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Poem _$PoemFromJson(Map<String, dynamic> json) => Poem(
      title: json['title'] as String,
      content: json['content'] as String,
      previewContent: json['previewContent'] as String,
      poemTopicName: json['poemTopicName'] as String,
      poemTopicAssetLocation: json['poemTopicAssetLocation'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$PoemToJson(Poem instance) => <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'previewContent': instance.previewContent,
      'poemTopicName': instance.poemTopicName,
      'poemTopicAssetLocation': instance.poemTopicAssetLocation,
      'isFavorite': instance.isFavorite,
    };
