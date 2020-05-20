import 'dart:convert';

import 'package:anagramapp/core/errors/exceptions.dart';
import 'package:anagramapp/features/anagram_finder/data/models/anagrams_model.dart';
import 'package:anagramapp/features/anagram_finder/domain/entities/anagrams.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

abstract class AnagramRemoteDataSource {
  Future<Anagrams> getAnagrams(String letters);
}

class AnagramRemoteDataSourceImpl implements AnagramRemoteDataSource {
  final http.Client client;

  AnagramRemoteDataSourceImpl({@required this.client});

  @override
  Future<Anagrams> getAnagrams(String letters) async {
    http.Response response = await client.get('http://anagramica.com/all/:$letters');
    if (response.statusCode == 200) {
      return AnagramsModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
