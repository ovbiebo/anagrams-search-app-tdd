import 'package:equatable/equatable.dart';

abstract class AnagramsEvent extends Equatable {
  AnagramsEvent([List props = const <dynamic>[]]): super(props);
}

class GetAnagramsForLetters extends AnagramsEvent{
  final String letters;

  GetAnagramsForLetters({this.letters}): super([letters]);
}