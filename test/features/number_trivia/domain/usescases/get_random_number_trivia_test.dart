import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/usescases/usecase.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repositories.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usescases/get_random_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepositories extends Mock
    implements NumberTriviaRepositories {}

void main() {
  late GetRandomNumberTrivia useCase;
  late MockNumberTriviaRepositories mockNumberTriviaRepositories;
  //init => run before test run
  setUp(() {
    mockNumberTriviaRepositories = MockNumberTriviaRepositories();
    useCase = GetRandomNumberTrivia(mockNumberTriviaRepositories);
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: 'Number is one');

  test('Should get trivia for the from the repository', () async {
    //arrange
    when(
      mockNumberTriviaRepositories.getRandomNumberTrivia(),
    ).thenAnswer((_) async => Right(tNumberTrivia));

    ///act
    final result = await useCase.call(NoPrams());

    ///assert
    expect(result, Right(tNumberTrivia));

    ///verify
    verify(mockNumberTriviaRepositories.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepositories);
  });
}
