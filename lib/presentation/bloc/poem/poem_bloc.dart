import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nevesomiy/data/data.dart';
import 'package:nevesomiy/domain/domain.dart';

part 'poem_event.dart';
part 'poem_state.dart';

class PoemBloc extends Bloc<PoemEvent, PoemState> {
  final Poem poem;
  final CacheService cacheService;
  PoemBloc({
    required this.poem
  }) : cacheService = CacheService.instance,
    super(
      PoemState(
        poem: poem 
    )) {
      on<PoemEvent>(_onEvent); 
    }

   void _onEvent(
    PoemEvent event,
    Emitter<PoemState> emit,
  ) {
    if (event is PoemAction) return _onAction(event, emit);
  }

  void _onAction(
    PoemAction event,
    Emitter<PoemState> emit,
  ) async {

    var poems = cacheService.getPoems();
    poems = poems.map<Poem>((e) {
      if(e.title == poem.title) {
       return e.copyWith(isFavorite: event.isFavorite);
      } else {
        return e;
      }
    }).toList();

    

    cacheService.savePoems(poems);
    emit(state.copyWith(
      poem: poem.copyWith(
        isFavorite: event.isFavorite
      )
    ));
  }
}
