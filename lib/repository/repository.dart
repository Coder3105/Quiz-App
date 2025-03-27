import 'dart:convert';
import 'package:groq/groq.dart';
import '../models/quiz_question.dart';

class QuizRepository {
  final Groq groqClient = Groq(
    apiKey: "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", 
    model: "llama3-8b-8192",
  );

  Future<List<QuizQuestion>> fetchQuestions(String difficulty, String category) async {
    try {
      groqClient.startChat();

      GroqResponse response = await groqClient.sendMessage(
        "Generate exactly 5 multiple-choice questions on the topic of **$category**. "
        "The difficulty level should be **$difficulty**. "
        "Each question should have 4 options, with one correct answer clearly marked. "
        "Return the response as a **valid JSON array only** without any extra text. "
        "JSON format: "
        "[{\"question\": \"What is the capital of France?\", "
        "\"options\": [\"Berlin\", \"Madrid\", \"Paris\", \"Rome\"], "
        "\"correctAnswer\": \"Paris\"}]",
      );

      String extractedJson = response.choices.first.message.content.trim();

      List<dynamic> questionsJson = jsonDecode(extractedJson);
      List<QuizQuestion> questions =
          questionsJson.map((q) => QuizQuestion.fromJson(q)).toList();

      return questions;
    } catch (e) {
      throw Exception("Error fetching quiz questions: $e");
    }
  }
}
