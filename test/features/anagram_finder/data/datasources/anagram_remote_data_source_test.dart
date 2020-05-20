import 'dart:convert';

import 'package:anagramapp/core/errors/exceptions.dart';
import 'package:anagramapp/features/anagram_finder/data/datasources/anagram_remote_data_source.dart';
import 'package:anagramapp/features/anagram_finder/data/models/anagrams_model.dart';
import 'package:matcher/matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  AnagramRemoteDataSourceImpl remoteDataSourceImpl;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSourceImpl = AnagramRemoteDataSourceImpl(client: mockHttpClient);
  });

  final String tLetters = 'eta';
  final AnagramsModel tAnagramsModel = AnagramsModel.fromJson(json.decode(fixture('anagrams.json')));

  test(
    'Should perform a GET request on a url with letters being the endpoint',
    () {
      //arrange
      when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(fixture('anagrams.json'), 200));
      //act
      remoteDataSourceImpl.getAnagrams(tLetters);
      //assert
      verify(mockHttpClient.get('anagramica.com/all/:$tLetters'));
    },
  );

  test(
    'Should return AnagramsModel if GET request is successful',
    () async {
      //arrange
      when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(fixture('anagrams.json'), 200));
      //act
      final result = await remoteDataSourceImpl.getAnagrams(tLetters);
      //assert
      expect(result, tAnagramsModel);
    },
  );

  test(
    'Should throw ServerException if GET request fails',
    () {
      //arrange
      when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(fixture('anagrams.json'), 404));
      //act
      final call = remoteDataSourceImpl.getAnagrams;
      //assert
      expect(() => call(tLetters), throwsA(TypeMatcher<ServerException>()));
    },
  );
}
