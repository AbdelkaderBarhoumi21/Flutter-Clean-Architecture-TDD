import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/usescases/usecase.dart';
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

    expect(numberTriviaBloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() {
      when(
        mockInputConverter.stringToUnsignedInteger(any),
      ).thenReturn(Right(tNumberParsed));
    }

    test(
      'Should call input converter to validate and convert the string to an unsigned integer',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(
          mockGetConcreteNumberTrivia(any),
        ).thenAnswer((_) async => Right(tNumberTrivia));
        //act
        numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));

        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        //assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test('Should emit [Error] state when input is invalid', () async {
      //arrange
      when(
        mockInputConverter.stringToUnsignedInteger(any),
      ).thenReturn(Left(InvalidInputFailure()));
      //assert later => 30 second then test fail
      //bloc will emit by default Empty that's why we added it here
      final expected = [Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
      //act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    ///Test AAA => Arrange , Act ,Assert
    test('Should get data from the concrete use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(
        mockGetConcreteNumberTrivia(any),
      ).thenAnswer((_) async => Right(tNumberTrivia));

      // act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));

      await untilCalled(mockGetConcreteNumberTrivia(any));

      // assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test(
      'Should emit [loading,loaded] when data is gotten successfully',
      () async {
        //arrange
        setUpMockInputConverterSuccess();

        when(
          mockGetConcreteNumberTrivia(any),
        ).thenAnswer((_) async => Right(tNumberTrivia));

        // assert initial state separately
        expect(numberTriviaBloc.state, equals(Empty()));

        // assert stream emissions
        final expected = [Loading(), Loaded(trivia: tNumberTrivia)];
        expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
        //act
        numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
    test('Should emit [loading,Error] when data is failed ', () async {
      //arrange
      setUpMockInputConverterSuccess();

      when(
        mockGetConcreteNumberTrivia(any),
      ).thenAnswer((_) async => left(ServerFailure()));

      // assert initial state separately
      expect(numberTriviaBloc.state, equals(Empty()));

      // assert stream emissions
      final expected = [Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
      //act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
    test(
      'Should emit [loading,Error] with a proper message for the error when getting data fails  ',
      () async {
        //arrange
        setUpMockInputConverterSuccess();

        when(
          mockGetConcreteNumberTrivia(any),
        ).thenAnswer((_) async => left(CacheFailure()));

        // assert initial state separately
        expect(numberTriviaBloc.state, equals(Empty()));

        // assert stream emissions
        final expected = [Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
        expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
        //act
        numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });
  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    ///Test AAA => Arrange , Act ,Assert
    test('Should get data from the concrete use case', () async {
      // arrange
      when(
        mockGetRandomNumberTrivia(NoPrams()),
      ).thenAnswer((_) async => Right(tNumberTrivia));

      // act
      numberTriviaBloc.add(GetTriviaForRandomNumber());

      await untilCalled(mockGetRandomNumberTrivia(any));

      // assert
      verify(mockGetRandomNumberTrivia(NoPrams()));
    });

    test(
      'Should emit [loading,loaded] when data is gotten successfully',
      () async {
        //arrange

        when(
          mockGetRandomNumberTrivia(any),
        ).thenAnswer((_) async => Right(tNumberTrivia));

        // assert initial state separately
        expect(numberTriviaBloc.state, equals(Empty()));

        // assert stream emissions
        final expected = [Loading(), Loaded(trivia: tNumberTrivia)];
        expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
        //act
        numberTriviaBloc.add(GetTriviaForRandomNumber());
      },
    );
    test('Should emit [loading,Error] when data is failed ', () async {
      //arrange
      when(
        mockGetRandomNumberTrivia(any),
      ).thenAnswer((_) async => left(ServerFailure()));

      // assert initial state separately
      expect(numberTriviaBloc.state, equals(Empty()));

      // assert stream emissions
      final expected = [Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
      //act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });
    test(
      'Should emit [loading,Error] with a proper message for the error when getting data fails  ',
      () async {
        //arrange


        when(
          mockGetRandomNumberTrivia(any),
        ).thenAnswer((_) async => left(CacheFailure()));

        // assert initial state separately
        expect(numberTriviaBloc.state, equals(Empty()));

        // assert stream emissions
        final expected = [Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
        expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
        //act
        numberTriviaBloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
