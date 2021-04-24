import 'package:anagramapp/core/errors/failure.dart';
import 'package:anagramapp/features/anagram_finder/domain/entities/anagrams.dart';
import 'package:anagramapp/features/anagram_finder/domain/usecases/get_anagrams.dart';
import 'package:anagramapp/features/anagram_finder/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetAnagrams extends Mock implements GetAnagrams {}

void main() {
  MockGetAnagrams mockGetAnagrams;
  AnagramsBloc anagramsBloc;

  setUp(() {
    mockGetAnagrams = MockGetAnagrams();
    anagramsBloc = AnagramsBloc(getAnagrams: mockGetAnagrams);
  });

  test('Should emit WaitingForInputState as initial state', () {
    expect(anagramsBloc.initialState, WaitingForInputState());
  });

  final String tLetters = 'eta';
  final tAnagrams = Anagrams(all: ['eat', 'tea', 'at']);

  test(
    'Should get data from the GetAnagrams usecase',
    () async {
      //arrange
      when(mockGetAnagrams(letters: anyNamed('letters')))
          .thenAnswer((_) => Future.value(Right(tAnagrams)));
      //act
      anagramsBloc.add(GetAnagramsForLetters(letters: tLetters));
      await untilCalled(mockGetAnagrams(letters: anyNamed('letters')));
      //assert
      verify(mockGetAnagrams(letters: tLetters));
    },
  );

  test(
    'Should emit [Loading, Loaded] when getting data succeeds',
    () {
      //arrange
      when(mockGetAnagrams(letters: anyNamed('letters')))
          .thenAnswer((_) => Future.value(Right(tAnagrams)));
      //assert later
      expectLater(
        anagramsBloc.state,
        emitsInOrder([
          WaitingForInputState(),
          LoadingState(),
          LoadedState(anagrams: tAnagrams),
        ]),
      );
      //act
      anagramsBloc.add(GetAnagramsForLetters(letters: tLetters));
    },
  );

  test(
    'Should emit [Loading, Error] with ServerFailure message when getting data fails',
    () {
      //arrange
      when(mockGetAnagrams(letters: anyNamed('letters')))
          .thenAnswer((_) => Future.value(Left(ServerFailure())));
      //assert later
      expectLater(
        anagramsBloc.state,
        emitsInOrder([
          WaitingForInputState(),
          LoadingState(),
          ErrorState(errorMessage: SERVER_FAILURE_MESSAGE),
        ]),
      );
      //act
      anagramsBloc.add(GetAnagramsForLetters(letters: tLetters));
    },
  );

  test(
    'Should emit [Loading, Error] with DataConnectionFailure message when getting data fails',
    () {
      //arrange
      when(mockGetAnagrams(letters: anyNamed('letters')))
          .thenAnswer((_) => Future.value(Left(DataConnectionFailure())));
      //assert later
      expectLater(
        anagramsBloc.state,
        emitsInOrder([
          WaitingForInputState(),
          LoadingState(),
          ErrorState(errorMessage: DATA_CONNECTION_FAILURE_MESSAGE),
        ]),
      );
      //act
      anagramsBloc.add(GetAnagramsForLetters(letters: tLetters));
    },
  );
}
