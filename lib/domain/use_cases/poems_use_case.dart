import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:nevesomiy/data/data.dart';
import 'package:nevesomiy/data/failure.dart';
import 'package:nevesomiy/domain/domain.dart';
import 'package:nevesomiy/domain/entites/ettities.dart';
import 'package:nevesomiy/utils/utils.dart';

class PoemsUseCase {
  final FireStoreService fireStoreService;
  final CacheService cacheService;
  PoemsUseCase()  : 
  cacheService = CacheService.instance,
  fireStoreService = FireStoreService.instance;

  Future<Either<Failure, List<Poem>>> doRemotePoems() async {
    await cacheService.initialise();
    try {
      var documentSnapshotResult = await fireStoreService.getPoemsCollection();
      var result = documentSnapshotResult.data()?.map((key, value) {
        value as Map<String, dynamic>;
        return MapEntry(
          key,
          Poem(
            title: value.keys.first,
            content: PoemParser.byBreakContent(value.values.first),
            previewContent: PoemParser.byPreviewContent(value.values.first),
            poemTopicName: PoemParser.byTopicId(key).$1,
            poemTopicAssetLocation: PoemParser.byTopicId(key).$2,
            isFavorite: false
          )
        );
      }).values.toList();
        cacheService.savePoems(result ?? []);   
        return Right(result ?? []);  
    } on FirebaseException catch (e) {
        return Left(FireBaseFailure(error: e));
    }
  }

  Future<List<Poem>> doLocalPoems() async{
    await cacheService.initialise();
    return cacheService.getPoems();
  }

  List<Poem> sortPoemsByTopic(Topics value, List<Poem> poems) {
    if (value != Topics.all) {
      if (value == Topics.favorite) {
        poems = poems.where((element) => element.isFavorite ?? false).toList();
      } else {
        poems = poems.where((element) => element.poemTopicName == value.nameAndLocation.$1).toList();
      }
    } 
    return poems;   
  }

  List<Poem> poemMakeFavorite(Poem poem,  bool? isFavorite) {
    var poems = cacheService.getPoems();
    poems = poems.map<Poem>((e) {
      if(e.title == poem.title) {
       return e.copyWith(isFavorite: isFavorite);
      } else {
        return e;
      }
    }).toList();
    cacheService.savePoems(poems);
    return poems;
  }
}