import 'package:anagramapp/core/errors/exceptions.dart';
import 'package:anagramapp/core/errors/failure.dart';
import 'package:anagramapp/core/network/network_info.dart';
import 'package:anagramapp/features/anagram_finder/data/datasources/anagram_remote_data_source.dart';
import 'package:anagramapp/features/anagram_finder/domain/entities/anagrams.dart';
import 'package:anagramapp/features/anagram_finder/domain/repositories/anagram_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class AnagramRepositoryImpl implements AnagramRepository {
  final NetworkInfo networkInfo;
  final AnagramRemoteDataSource remoteDataSource;

  AnagramRepositoryImpl({
    @required this.networkInfo,
    @required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Anagrams>> getAnagrams(String letters) async {
    if(await networkInfo.isConnected){
      try{
        final anagrams = await remoteDataSource.getAnagrams(letters);
        return Right(anagrams);
      }on ServerException{
        return Left(ServerFailure());
      }
    }else{
      return Left(DataConnectionFailure());
    }
  }
}