import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/usescases/usecase.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repositories.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoPrams> {
  final NumberTriviaRepositories repository;
  const GetRandomNumberTrivia(this.repository);
  @override
  Future<Either<Failure, NumberTrivia>> call(NoPrams params) async {
    return await repository.getRandomNumberTrivia();
  }
}


