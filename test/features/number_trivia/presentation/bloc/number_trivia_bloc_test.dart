import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/utils/input_converter.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usescases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usescases/get_random_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late NumberTriviaBloc numberTriviaBloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    numberTriviaBloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initial state should be empty', () {
    //assert

    expect(numberTriviaBloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);
    test(
      'Should call input converter to validate and convert the string to an unsigned integer',
      () async {
        //arrange

        when(
          mockInputConverter.stringToUnsignedInteger(any),
        ).thenReturn(Right(tNumberParsed));
        //act
        numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));

        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        //assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test('Should emit [Error] state when input is valid', () async {
      //arrange
      when(
        mockInputConverter.stringToUnsignedInteger(any),
      ).thenReturn(Left(InvalidInputFailure()));
      //assert later => 30 second then test fail
      //bloc will emit by default Empty that's why we added it here
      final expected = [Empty(), Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));
      //act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });
}
