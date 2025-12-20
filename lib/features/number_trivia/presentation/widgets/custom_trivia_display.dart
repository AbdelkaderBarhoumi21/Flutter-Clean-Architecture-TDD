import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

class CustomTriviaDisplay extends StatelessWidget {
  const CustomTriviaDisplay({required this.numberTrivia, super.key});

  final NumberTrivia numberTrivia;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: Column(
          children: [
            Text(
              numberTrivia.number.toString(),
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    numberTrivia.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
