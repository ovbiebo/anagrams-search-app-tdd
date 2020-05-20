import 'dart:convert';

import 'package:anagramapp/features/anagram_finder/data/models/anagrams_model.dart';
import 'package:anagramapp/features/anagram_finder/domain/entities/anagrams.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  AnagramsModel anagramsModel;

  setUp(() {
    anagramsModel = AnagramsModel(all: ['eat', 'tea', 'ate', 'at']);
  });

  test('Should be a subclass of Anagrams', () {
    //assert
    expect(anagramsModel, isA<Anagrams>());
  });

  test('Should return a valid model from JSON', () async {
    //arrange
    final Map<String, dynamic> jsonMap = json.decode(fixture('anagrams.json'));
    //act
    final result = AnagramsModel.fromJson(jsonMap);
    //assert
    expect(result, equals(anagramsModel));
  });
}
