import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nevesomiy/data/data.dart';
import 'package:nevesomiy/domain/domain.dart';
import 'package:nevesomiy/domain/entites/ettities.dart';
import 'package:nevesomiy/utils/utils.dart';

part 'poems_event.dart';
part 'poems_state.dart';

class PoemsBloc extends Bloc<PoemsEvent, PoemsState> {
  final FireStoreService fireStoreservice;
  final CacheService cacheService;
  final FireBaseNotificationService fireBaseNotificationService;

  PoemsBloc()
      : fireStoreservice = FireStoreService.instance,
        cacheService = CacheService.instance,
        fireBaseNotificationService = FireBaseNotificationService.instance,
        super(PoemsLoading()) {
    on<PoemsEvent>(_onEvent);
  }

  List<Poem> poems = [];

  Future<void>? _onEvent(
    PoemsEvent event,
    Emitter<PoemsState> emit,
  ) {
    if (event is PoemsCheckUpdates) return _onNeedsForUpdate(event, emit);
    if (event is PoemsLoad) return _onLoad(event, emit);
    if (event is PoemsSortByType) return _onSort(event, emit);
    return null;
  }

  Future<void> _onNeedsForUpdate(
      PoemsCheckUpdates event, Emitter<PoemsState> emit) async {
    fireBaseNotificationService.getToken();

    await emit.forEach<RemoteMessage>(
        fireBaseNotificationService.myOutAppStream, onData: (message) {
      if (message.messageId != null) {
        return const PoemsCheckForUpdate(needsForUpdate: true);
      } else {
        return const PoemsCheckForUpdate(needsForUpdate: false);
      }
    });
  }

  Future<void> _onLoad(PoemsLoad event, Emitter<PoemsState> emit) async {
    await cacheService.initialise();

    if (event.syncWithFireStore) {
        log('REMOTE');
        var result = await fireStoreservice.getPoemsCollection();

        result?.fold((falure) => emit(PoemsError(error: falure.message)),
            (right) {
          var result = right.data()?.map((key, value) {
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
                ));
          }).values;
          poems = result?.toList() ?? [];
          cacheService.savePoems(poems);
        });
    } else {
     log('LOCAL');
      poems = cacheService.getPoems();
    }

    emit(PoemsLoaded(
        poems: poems, value: cacheService.getTopic(), isSortedState: false));
  }

  Future<void> _onSort(PoemsSortByType event, Emitter<PoemsState> emit) async {
    emit(PoemsLoading());

    await Future.delayed(const Duration(milliseconds: 500), () {});

    poems = cacheService.getPoems();

    if (event.value != Topics.all) {
      if (event.value == Topics.favorite) {
        poems = poems.where((element) => element.isFavorite ?? false).toList();
      } else {
        poems = poems
            .where((element) =>
                element.poemTopicName == event.value.nameAndLocation.$1)
            .toList();
      }
    }

    cacheService.saveTopic(event.value.name);

    emit(PoemsLoaded(poems: poems, value: event.value, isSortedState: true));
  }
}
