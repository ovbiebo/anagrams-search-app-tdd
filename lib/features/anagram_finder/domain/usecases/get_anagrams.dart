import 'package:anagramapp/core/errors/failure.dart';
import 'package:anagramapp/core/usecases/usecase.dart';
import 'package:anagramapp/features/anagram_finder/domain/entities/anagrams.dart';
import 'package:anagramapp/features/anagram_finder/domain/repositories/anagram_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class GetAnagrams implements Usecase<Anagrams>{
  final AnagramRepository repository;

  GetAnagrams({@required this.repository});

  Future<Either<Failure, Anagrams>> call ({@required String letters}) async{
    return await repository.getAnagrams(letters);
  }
}