import 'dart:convert';

import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(text: 'Test Text', number: 1);

  test('Should be subclass of numbertrivia entity', () async {
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test(
      'Should return a valid model when the json number is an integer',
      () async {
        //arrange
        final Map<String, dynamic> jsonMap = json.decode(
          fixtures('trivia.json'),
        );
        //act

        final result = NumberTriviaModel.fromJson(jsonMap);

        //assert
        expect(result, tNumberTriviaModel);
      },
    );
    test(
      'Should return a valid model when the json number is an double',
      () async {
        //arrange
        final Map<String, dynamic> jsonMap = json.decode(
          fixtures('trivia_double.json'),
        );
        //act

        final result = NumberTriviaModel.fromJson(jsonMap);

        //assert
        expect(result, tNumberTriviaModel);
      },
    );
  });
  group("ToJson", () {
    test('Should return a json map containing the proper data', () async {
      //act
      final result = tNumberTriviaModel.toJson();
      //assert
      final expectedMap = {"text": "Test Text", "number": 1};
      expect(result, expectedMap);
    });
  });
}
