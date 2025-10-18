import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  // const NumberTriviaModel({required String text, required int number})
  //   : super(number: number, text: text);
  const NumberTriviaModel({required super.text, required super.number});

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    ///num can be both => double or int instead of cast
    return NumberTriviaModel(
      text: json['text'],
      number: (json['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'number': number};
  }
}
