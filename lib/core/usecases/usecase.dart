import 'package:anagramapp/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class Usecase<Type> {
  Future<Either<Failure, Type>> call();
}