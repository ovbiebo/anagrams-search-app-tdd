import 'package:anagramapp/features/anagram_finder/domain/entities/anagrams.dart';
import 'package:equatable/equatable.dart';

abstract class AnagramsState extends Equatable {
  AnagramsState([List props = const <dynamic>[]]): super(props);
}

class WaitingForInputState extends AnagramsState {}
class LoadingState extends AnagramsState {}
class LoadedState extends AnagramsState {
  final Anagrams anagrams;

  LoadedState({this.anagrams}): super([anagrams]);
}
class ErrorState extends AnagramsState {
  final String errorMessage;

  ErrorState({this.errorMessage}) : super([errorMessage]);
}
