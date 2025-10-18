import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/platform/network_info.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/local/number_trivia_local_datasource.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/remote/number_trivia_remote_datasource.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repositories.dart';

class NumberTriviaRepositoriesImpl implements NumberTriviaRepositories {
  final NumberTriviaRemoteDatasource remoteDataSource;
  final NumberTriviaLocalDatasource localDataSource;
  final NetworkInfo networkInfo;
  NumberTriviaRepositoriesImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await remoteDataSource.getConcreteNumberTrivia(
          number,
        );
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerExceptions {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    throw UnimplementedError();
  }
}
