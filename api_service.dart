import 'dart:convert';
import 'package:http/http.dart' as http;
import '../s/model/question.dart';

class ApiService {
  Future<List<Question>> fetchQuestions(String category) async {
    String difficulty;
    if (category == 'Easy') {
      difficulty = 'easy';
    } else if (category == 'Medium') {
      difficulty = 'medium';
    } else if (category == 'Difficult') {
      difficulty = 'hard';
    } else {
      // For Live Match, we can use a different endpoint or handle it differently
      difficulty = 'medium'; // Placeholder
    }

    final response = await http.get(Uri.parse('https://opentdb.com/api.php?amount=30&category=21&difficulty=$difficulty&type=multiple'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['results'];
      return jsonResponse.map((data) => Question.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
