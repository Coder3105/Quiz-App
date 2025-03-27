import 'dart:convert';
import 'package:quiz_app_test/repository/api_client,dart';
import '../models/quiz_question.dart';

class QuizRepository {
  final ApiClient apiClient = ApiClient(apiKey: "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");

  Future<List<QuizQuestion>> fetchQuestions(String difficulty, String category) async {
    try {
      final Map<String, dynamic> requestPayload = {
        "model": "llama3-8b-8192",
        "messages": [
          {
            "role": "system",
            "content": "Generate exactly 5 multiple-choice questions on the topic of **$category**. "
                "The difficulty level should be **$difficulty**. "
                "Each question should have 4 options, with one correct answer clearly marked. "
                "Return the response as a **valid JSON array only** without any extra text. "
                "JSON format: "
                "[{\"question\": \"What is the capital of France?\", "
                "\"options\": [\"Berlin\", \"Madrid\", \"Paris\", \"Rome\"], "
                "\"correctAnswer\": \"Paris\"}]"
          }
        ]
      };

      final responseJson = await apiClient.makeRequest(requestPayload);
      String extractedJson = responseJson['choices'][0]['message']['content'].trim();
      List<dynamic> questionsJson = jsonDecode(extractedJson);
      List<QuizQuestion> questions = questionsJson.map((q) => QuizQuestion.fromJson(q)).toList();
      return questions;
    } catch (e) {
      throw Exception("Error fetching quiz questions: $e");
    }
  }
}
