import 'dart:convert';

import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/remote/number_trivia_remote_datasource.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixtures_reader.dart';
import 'number_trivia_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDatasourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();

    dataSource = NumberTriviaRemoteDatasourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess() {
    when(
      mockHttpClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response(fixtures('trivia.json'), 200));
  }

  void setUpMockHttpClientSeverException() {
    when(
      mockHttpClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;

    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixtures('trivia.json')),
    );

    test(
      '''should perform a GET request on a URL with number being the endpoint 
      and with application/json header''',
      () async {
        //arrange
        setUpMockHttpClientSuccess();
        //act
        dataSource.getConcreteNumberTrivia(tNumber);

        //assert

        verify(
          mockHttpClient.get(
            Uri.parse('http://127.0.0.1:8083/$tNumber'),
            headers: {'Content-Type': 'applications/json'},
          ),
        );
      },
    );

    test(
      'Should return Number trivia model when the response code is 200 => success',
      () async {
        //arrange
        setUpMockHttpClientSuccess();
        //act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);

        //assert

        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'Should throw a ServerException when the response code is 404 or other',
      () async {
        //arrange
        setUpMockHttpClientSeverException();
        //act

        final call = dataSource.getConcreteNumberTrivia;

        //assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerExceptions>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixtures('trivia.json')),
    );
        test(
      '''should perform a GET request on a URL with number being the endpoint 
      and with application/json header''',
      () async {
        //arrange
        setUpMockHttpClientSuccess();
        //act
        dataSource.getRandomNumberTrivia();

        //assert

        verify(
          mockHttpClient.get(
            Uri.parse('http://127.0.0.1:8083/random'),
            headers: {'Content-Type': 'applications/json'},
          ),
        );
      },
    );
    test(
      'Should return Number trivia model when the response code is 200 => success ',
      () async {
        //arrange
        setUpMockHttpClientSuccess();

        //act

        final result = await dataSource.getRandomNumberTrivia();

        //assert
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'Should throw a ServerException when the response code is 404 or other',
      () async {
        //arrange
        setUpMockHttpClientSeverException();

        //act

        final call =  dataSource.getRandomNumberTrivia;

        //assert
        expect(()=>call(), throwsA(TypeMatcher<ServerExceptions>()));
      },
    );
  });
}
