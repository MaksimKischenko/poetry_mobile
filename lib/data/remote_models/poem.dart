
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'poem.g.dart';

@immutable
@JsonSerializable()
class Poem extends Equatable {
  final String title;
  final String content;
  final String previewContent;
  final String poemTopicName;
  final String poemTopicAssetLocation;
  final bool? isFavorite;

  const Poem({
    required this.title,
    required this.content,
    required this.previewContent,
    required this.poemTopicName,
    required this.poemTopicAssetLocation,
    this.isFavorite = false
  });

  static Poem fromJson(JsonMap json) => _$PoemFromJson(json);

  JsonMap toJson() => _$PoemToJson(this);


  @override
  List<Object?> get props => [title, content, poemTopicName, poemTopicAssetLocation, previewContent, isFavorite];


  @override
  bool get stringify => true;

  Poem copyWith({
    String? title,
    String? content,
    String? previewContent,
    String? poemTopicName,
    String? poemTopicAssetLocation,
    bool? isFavorite,
  }) {
    return Poem(
      title: title ?? this.title,
      content: content ?? this.content,
      previewContent: previewContent ?? this.previewContent,
      poemTopicName: poemTopicName ?? this.poemTopicName,
      poemTopicAssetLocation: poemTopicAssetLocation ?? this.poemTopicAssetLocation,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

typedef JsonMap = Map<String, dynamic>;