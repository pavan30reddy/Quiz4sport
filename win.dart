import 'package:flutter/material.dart';

import 'home.dart';
import 'quiz.dart';

class WinningScreen extends StatelessWidget {
  final int score;
  final int coins = 50; // Example coins earned

  WinningScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    String gesture;
    if (score > 20) {
      gesture = 'Celebrate!';
    } else if (score >= 10) {
      gesture = 'Good Try!';
    } else {
      gesture = 'Better Luck Next Time!';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Winning Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              gesture,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Your Score: $score',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Coins Earned: $coins',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
                );
              },
              child: Text('Return to Home'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen(category: 'Your Category')), // Replace 'Your Category' with the actual category
                  (route) => false,
                );
              },
              child: Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}

