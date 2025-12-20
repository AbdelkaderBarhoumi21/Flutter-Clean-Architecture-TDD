import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class CustomTriviaControls extends StatefulWidget {
  const CustomTriviaControls({super.key});

  @override
  State<CustomTriviaControls> createState() => _CustomTriviaControlsState();
}

class _CustomTriviaControlsState extends State<CustomTriviaControls> {
  final controller = TextEditingController();
  late String inputString;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            inputString = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: dispatchConcrete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Text('Search', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: dispatchRandom,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: Text(
                  'Get random trivia',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(
      context,
    ).add(GetTriviaForConcreteNumber(inputString));
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
