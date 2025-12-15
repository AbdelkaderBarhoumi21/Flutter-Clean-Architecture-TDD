import 'dart:convert';

import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/local/number_trivia_local_datasource.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixtures_reader.dart';
import 'number_trivia_local_datasource_test.mocks.dart';

//class MockSharedPref extends Mock implements SharedPreferences{} ==@GenerateMocks([SharedPreferences])
@GenerateMocks([SharedPreferences])
void main() {
  late NumberTriviaLocalDatasourceImpl numberTriviaLocalDatasourceImpl;
  late MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDatasourceImpl = NumberTriviaLocalDatasourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumbertriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixtures('trivia_cached.json')),
    );
    test(
      'Should return number trivia from shared pref when there is one the cache',
      () async {
        //arrange
        //then answer => future and thenReturn => type
        when(
          mockSharedPreferences.getString(any),
        ).thenReturn(fixtures('trivia_cached.json'));
        //act
        final result = await numberTriviaLocalDatasourceImpl
            .getLastNumberTrivia();
        //verify
        //verify ensure that a fct are called on mocked object correctly
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));

        //assert
        expect(result, equals(tNumbertriviaModel));
      },
    );
    test(
      'Should throw a cache exception when there is not a cached value',
      () async {
        //arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        //act
        final call = numberTriviaLocalDatasourceImpl.getLastNumberTrivia;
        //assert
        //updated to use the more modern isA<T>() matcher instead of TypeMatcher<T>
        expect(() => call(), throwsA(isA<CacheException>()));
        //verify
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      },
    );
  });
  group('Cached Number trivia', () {
    final tNumberTriviaModel = NumberTriviaModel(
      number: 1,
      text: 'test trivia',
    );
    test('Should call Shared pref to cache the data', () async {
      //arrange
      when(
        mockSharedPreferences.setString(any, any),
      ).thenAnswer((_) async => true);
      //act
      await numberTriviaLocalDatasourceImpl.cacheNumberTrivia(
        tNumberTriviaModel,
      );
      //assert
      final excpectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(
        mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA,
          excpectedJsonString,
        ),
      );
    });
  });
}


/*
verify(mock.method()) - Vérifie qu'elle a été appelée exactement 1 fois
verifyNever(mock.method()) - Vérifie qu'elle n'a jamais été appelée
verify(mock.method()).called(3) - Vérifie qu'elle a été appelée 3 fois
verifyInOrder([...]) - Vérifie l'ordre des appels
*/