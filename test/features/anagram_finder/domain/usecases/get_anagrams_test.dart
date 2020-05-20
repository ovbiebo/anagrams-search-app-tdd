import 'package:anagramapp/features/anagram_finder/domain/entities/anagrams.dart';
import 'package:anagramapp/features/anagram_finder/domain/repositories/anagram_repository.dart';
import 'package:anagramapp/features/anagram_finder/domain/usecases/get_anagrams.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAnagramRepository extends Mock implements AnagramRepository{}

void main (){
  MockAnagramRepository mockAnagramRepository;
  GetAnagrams useCase;

  setUp((){
    mockAnagramRepository = MockAnagramRepository();
    useCase = GetAnagrams(repository: mockAnagramRepository);
  });

  final tLetters = 'eta';
  final tAnagrams = Anagrams(all: ['eat', 'tea', 'at']);

  test('Should get anagrams for letters from repository.', () async {
    //arrange
    when(mockAnagramRepository.getAnagrams(any)).thenAnswer((_) async => Right(tAnagrams));
    //act
    final result = await useCase(letters: tLetters);
    //assert
    expect(result, equals(Right(tAnagrams)));
    verify(mockAnagramRepository.getAnagrams(tLetters));
    verifyNoMoreInteractions(mockAnagramRepository);
  });
}