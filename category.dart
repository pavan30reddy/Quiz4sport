import 'package:flutter/material.dart';
import 'quiz.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class QuizCategoryScreen extends StatefulWidget {
  @override
  _QuizCategoryScreenState createState() => _QuizCategoryScreenState();
}

class _QuizCategoryScreenState extends State<QuizCategoryScreen> {
  final List<String> categories = [
    'Easy',
    'Medium',
    'Difficult',
    'Live Match'
  ];

  List<dynamic> liveMatchPolls = [];
  bool isLoading = true;
  bool loadFailed = false;

  @override
  void initState() {
    super.initState();
    fetchLiveMatchPolls();
  }

  Future<void> fetchLiveMatchPolls() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.example.com/live-match-polls'))
          .timeout(Duration(minutes: 1), onTimeout: () {
        setState(() {
          isLoading = false;
          loadFailed = true;
        });
        return http.Response('Error', 408); // Request Timeout response
      });

      if (response.statusCode == 200) {
        setState(() {
          liveMatchPolls = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load live match polls');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        loadFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length + (categories.contains('Live Match') ? liveMatchPolls.length : 0),
                    itemBuilder: (context, index) {
                      if (index < categories.length) {
                        return CategoryCard(categories[index]);
                      } else {
                        return LiveMatchPollCard(liveMatchPolls[index - categories.length]);
                      }
                    },
                  ),
                ),
                if (loadFailed)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Unable to load live match poll',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;

  CategoryCard(this.category);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuizScreen(category: category)),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              if (category == 'Easy')
                Icon(Icons.sentiment_satisfied, size: 40, color: Colors.green)
              else if (category == 'Medium')
                Icon(Icons.sentiment_neutral, size: 40, color: Colors.orange)
              else if (category == 'Difficult')
                Icon(Icons.sentiment_dissatisfied, size: 40, color: Colors.red)
              else if (category == 'Live Match')
                Column(
                  children: [
                    Icon(Icons.live_tv, size: 40, color: Colors.blue),
                    Text(
                      'Earn Rewards',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              SizedBox(width: 20),
              Text(
                category,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LiveMatchPollCard extends StatelessWidget {
  final dynamic poll;

  LiveMatchPollCard(this.poll);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              poll['title'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(poll['description']),
          ],
        ),
      ),
    );
  }
}
