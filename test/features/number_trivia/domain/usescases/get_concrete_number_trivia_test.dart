import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repositories.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usescases/get_concrete_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepositories extends Mock
    implements NumberTriviaRepositories {}

void main() {
  late GetConcreteNumberTrivia useCase;
  late MockNumberTriviaRepositories mockNumberTriviaRepositories;
  //init => run before test run
  setUp(() {
    mockNumberTriviaRepositories = MockNumberTriviaRepositories();
    useCase = GetConcreteNumberTrivia(mockNumberTriviaRepositories);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: tNumber, text: 'Number is one');

  test('Should get trivia for the number from the repository', () async {
    // "On the fly" implementation of the Repository using the Mockito package.
    // When getConcreteNumberTrivia is called with any argument, always answer with
    // the Right "side" of Either containing a test NumberTrivia object.

    //arrange
    // The "act" phase of the test. Call the not-yet-existent method.
    when(
      mockNumberTriviaRepositories.getConcreteNumberTrivia(tNumber),
    ).thenAnswer((_) async => Right(tNumberTrivia));

    ///act
    // UseCase should simply return whatever was returned from the Repository
    final result = await useCase.call(Params(number: tNumber));

    ///assert
    // Verify that the method has been called on the Repository
    expect(result, Right(tNumberTrivia));

    ///verify

    // Verify that the method has been called on the Repository
    verify(mockNumberTriviaRepositories.getConcreteNumberTrivia(tNumber));
    // Only the above method should be called and nothing more.
    verifyNoMoreInteractions(mockNumberTriviaRepositories);
  });
}
