import 'package:anagramapp/core/errors/failure.dart';
import 'package:anagramapp/features/anagram_finder/domain/entities/anagrams.dart';
import 'package:dartz/dartz.dart';

abstract class AnagramRepository {
  Future<Either<Failure, Anagrams>> getAnagrams(String letters);
}