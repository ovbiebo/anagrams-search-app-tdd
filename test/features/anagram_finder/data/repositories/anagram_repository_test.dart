import 'package:anagramapp/core/errors/exceptions.dart';
import 'package:anagramapp/core/errors/failure.dart';
import 'package:anagramapp/core/network/network_info.dart';
import 'package:anagramapp/features/anagram_finder/data/datasources/anagram_remote_data_source.dart';
import 'package:anagramapp/features/anagram_finder/data/models/anagrams_model.dart';
import 'package:anagramapp/features/anagram_finder/data/repositories/anagram_repository_impl.dart';
import 'package:anagramapp/features/anagram_finder/domain/entities/anagrams.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAnagramRemoteDataSource extends Mock
    implements AnagramRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  AnagramRepositoryImpl anagramRepositoryImpl;
  MockNetworkInfo mockNetworkInfo;
  MockAnagramRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAnagramRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    anagramRepositoryImpl = AnagramRepositoryImpl(
      networkInfo: mockNetworkInfo,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  final String tLetters = 'eta';
  final tHasConnection = Future<bool>.value(true);
  final tAnagramsModel = AnagramsModel(all: ['eat', 'tea', 'at']);
  final Anagrams tAnagrams = tAnagramsModel;

  test('Should check whether device is online', () {
    //arrange
    when(mockNetworkInfo.isConnected).thenAnswer((_) => tHasConnection);
    //act
    anagramRepositoryImpl.getAnagrams(tLetters);
    //assert
    verify(mockNetworkInfo.isConnected);
  });

  group('Device is online.', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
      'Should return Anagrams when call to remote data source succeeds',
      () async {
        //arrange
        when(mockRemoteDataSource.getAnagrams(any))
            .thenAnswer((_) async => tAnagramsModel);
        //act
        final result = await anagramRepositoryImpl.getAnagrams(tLetters);
        //assert
        expect(result, Right(tAnagrams));
        verify(mockRemoteDataSource.getAnagrams(tLetters));
      },
    );

    test(
      'Should return ServerFailure when call to remote data source fails',
      () async {
        //arrange
        when(mockRemoteDataSource.getAnagrams(any)).thenAnswer((_) {
          throw ServerException();
        });
        //act
        final result = await anagramRepositoryImpl.getAnagrams(tLetters);
        //assert
        expect(result, Left(ServerFailure()));
        verify(mockRemoteDataSource.getAnagrams(tLetters));
      },
    );
  });

  group('Device is offline.', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test('Should return DataConnetctionFailure', () async {
      //act
      final result = await anagramRepositoryImpl.getAnagrams(tLetters);
      //assert
      expect(result, Left(DataConnectionFailure()));
      verifyZeroInteractions(mockRemoteDataSource);
    });
  });
}
