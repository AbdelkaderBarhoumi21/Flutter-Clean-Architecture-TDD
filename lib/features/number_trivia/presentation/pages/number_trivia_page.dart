import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/di/injection_container.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Number Trivia')),
      body: SingleChildScrollView(child: NumberTriviaBody()),
    );
  }
}

class NumberTriviaBody extends StatelessWidget {
  const NumberTriviaBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serverLocator<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //Top half
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is Empty) {
                  return CustomMessageDisplay(message: 'Start searching!');
                } else if (state is Error) {
                  return CustomMessageDisplay(message: state.message);
                } else if (state is Loading) {
                  return CustomLoading();
                } else if (state is Loaded) {
                  return CustomTriviaDisplay(numberTrivia: state.trivia);
                }
                return SizedBox.shrink();
              },
            ),
            SizedBox(height: 20),
            //bottom half
            CustomTriviaControls(),
          ],
        ),
      ),
    );
  }
}

