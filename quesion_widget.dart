import 'package:flutter/material.dart';
import '../s/model/question.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final String? selectedOption;
  final Function(String) onOptionSelected;

  QuestionWidget({required this.question, required this.selectedOption, required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              question.question,
              style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 8, 140, 184)),
            ),
          ),
          ...question.options.map((option) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: selectedOption == option ? const Color.fromARGB(255, 35, 144, 5) : Colors.black, backgroundColor: selectedOption == option ? Colors.blue : Colors.white, // Text color
                ),
                onPressed: () {
                  onOptionSelected(option);
                },
                child: Text(option),
              )),
        ],
      ),
    );
  }
}
