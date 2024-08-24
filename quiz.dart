import 'package:flutter/material.dart';
import 'dart:async';
import '../serv/api_service.dart';
import '../widgett/quesion_widget.dart';
import 'model/question.dart';
import 'result.dart';

class QuizScreen extends StatefulWidget {
  final String category;

  QuizScreen({required this.category});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question>> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  Timer? _timer;
  int _timeLeft = 0;
  String? _selectedOption;
  List<bool> _results = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    _questions = ApiService().fetchQuestions(widget.category);
    _questions.then((value) {
      setState(() {
        _isLoading = false;
        _startTimer();
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      // Handle the error appropriately
      print('Error fetching questions: $error');
    });
  }

  void _startTimer() {
    switch (widget.category) {
      case 'Easy':
        _timeLeft = 30;
        break;
      case 'Medium':
        _timeLeft = 50;
        break;
      case 'Difficult':
        _timeLeft = 70;
        break;
      default:
        _timeLeft = 0; // No timer for Live Match
    }

    if (_timeLeft > 0) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _nextQuestion(false);
          }
        });
      });
    }
  }

  void _nextQuestion(bool isCorrect) {
    _results.add(isCorrect);
    if (isCorrect) {
      _score++;
    }
    if (_currentQuestionIndex < 29) { // Ensure we have 30 questions
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = null;
        _startTimer();
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(score: _score, total: 30, results: _results),
        ),
      );
    }
  }

  void _onOptionSelected(String option) {
    setState(() {
      _selectedOption = option;
    });
    _questions.then((questions) {
      _nextQuestion(option == questions[_currentQuestionIndex].correctAnswer);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.yellow, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : FutureBuilder<List<Question>>(
                future: _questions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Column(
                      children: <Widget>[
                        Text(
                          'Question ${_currentQuestionIndex + 1} of 30',
                          style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 2, 30, 31)),
                        ),
                        if (_timeLeft > 0)
                          Text(
                            'Time left: $_timeLeft seconds',
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          ),
                        QuestionWidget(
                          question: snapshot.data![_currentQuestionIndex],
                          selectedOption: _selectedOption,
                          onOptionSelected: _onOptionSelected,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            _onOptionSelected(_selectedOption!);
                          },
                          icon: Icon(Icons.arrow_forward),
                          label: Text('Move'),
                        ),
                      ],
                    );
                  }
                },
              ),
      ),
    );
  }
}
