// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'poems_bloc.dart';

sealed class PoemsEvent extends Equatable {
  const PoemsEvent();

  @override
  List<Object> get props => [];
}

final class PoemsLoad extends PoemsEvent {
  final bool syncWithFireStore;
  
  const PoemsLoad({
    required this.syncWithFireStore,
  });
}

final class PoemsCheckUpdates extends PoemsEvent {}

final class PoemsSortByType extends PoemsEvent {
  final Topics value;

   const PoemsSortByType({
    required this.value,
  }); 
}

