import 'package:flutter/material.dart';
import 'package:quiz_app_test/models/quiz_question.dart';
import 'package:quiz_app_test/screens/result_screen.dart';

class QuizScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  
  const QuizScreen({super.key, required this.questions});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _answered = false;

  void _checkAnswer(String selected) {
    if (!_answered) {
      setState(() {
        _selectedAnswer = selected;
        _answered = true;
        if (selected == widget.questions[_currentQuestionIndex].correctAnswer) {
          _score++;
        }
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(score: _score, total: widget.questions.length),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentQuestionIndex];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Center(child: Text('Question ${_currentQuestionIndex + 1} of ${widget.questions.length}',)), backgroundColor: Colors.blue),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                question.question,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ...question.options.map((option) => _buildOptionButton(option)),
              const SizedBox(height: 20),
              if (_answered)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, 
                    foregroundColor: Colors.white, 
                  ),
                  onPressed: _nextQuestion,
                  child: Text(_currentQuestionIndex < widget.questions.length - 1 ? 'Next' : 'See Results'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option) {
    bool isCorrect = option == widget.questions[_currentQuestionIndex].correctAnswer;
    bool isSelected = option == _selectedAnswer;

    return GestureDetector(
      onTap: () => _checkAnswer(option),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _answered
              ? (isSelected
                  ? (isCorrect ? Colors.green : Colors.red)
                  : Colors.grey.shade300)
              : const Color.fromARGB(255, 81, 83, 84),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          option,
          style: const TextStyle(fontSize: 18, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
