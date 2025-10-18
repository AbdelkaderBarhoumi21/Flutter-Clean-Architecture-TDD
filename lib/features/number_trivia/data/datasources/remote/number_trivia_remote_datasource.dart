import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDatasource {
  /// Calls the http://127.0.0.1:8083/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://127.0.0.1:8083/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
