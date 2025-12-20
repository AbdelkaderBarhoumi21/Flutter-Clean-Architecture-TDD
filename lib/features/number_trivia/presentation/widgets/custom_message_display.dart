import 'package:flutter/widgets.dart';

class CustomMessageDisplay extends StatelessWidget {
  const CustomMessageDisplay({required this.message, super.key});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: SingleChildScrollView(
        child: Text(
          message,
          style: TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
