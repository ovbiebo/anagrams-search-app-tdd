import 'package:meta/meta.dart';
import 'package:anagramapp/features/anagram_finder/domain/entities/anagrams.dart';

class AnagramsModel extends Anagrams {
  AnagramsModel({@required List<dynamic> all}) : super(all: all);

  factory AnagramsModel.fromJson(Map<String, dynamic> json) {
    return AnagramsModel(all: json["all"]);
  }
}
