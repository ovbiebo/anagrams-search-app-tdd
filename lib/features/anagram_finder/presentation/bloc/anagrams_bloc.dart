import 'dart:async';
import 'package:anagramapp/core/errors/failure.dart';
import 'package:anagramapp/features/anagram_finder/domain/usecases/get_anagrams.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

const String SERVER_FAILURE_MESSAGE = 'Server failure.';
const String DATA_CONNECTION_FAILURE_MESSAGE = 'Data connection unavailable.';

class AnagramsBloc extends Bloc<AnagramsEvent, AnagramsState> {
  final GetAnagrams getAnagrams;

  AnagramsBloc({
    @required this.getAnagrams,
  }) : assert(getAnagrams != null);

  @override
  AnagramsState get initialState => WaitingForInputState();

  @override
  Stream<AnagramsState> mapEventToState(
    AnagramsEvent event,
  ) async* {
    if (event is GetAnagramsForLetters) {
      yield LoadingState();
      final anagramsOrFailure = await getAnagrams(letters: event.letters);
      yield* anagramsOrFailure.fold(
        (failure) async* {
          if (failure is ServerFailure) {
            yield ErrorState(errorMessage: SERVER_FAILURE_MESSAGE);
          } else if (failure is DataConnectionFailure) {
            yield ErrorState(errorMessage: DATA_CONNECTION_FAILURE_MESSAGE);
          }
        },
        (anagrams) async* {
          yield LoadedState(anagrams: anagrams);
        },
      );
    }
  }
}
