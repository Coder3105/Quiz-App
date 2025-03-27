import 'package:flutter/material.dart';
import 'package:quiz_app_test/models/quiz_question.dart';
import 'package:quiz_app_test/screens/result_screen.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  const QuizScreen({super.key, required this.questions});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  Timer? _timer;
  int _timeLeft = 15;

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        _nextQuestion(0); 
      }
    });
  }

  void _nextQuestion(int score) {
    _timer?.cancel();
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _score += score;
        _currentQuestionIndex++;
        _isAnswered = false;
      });
      _startTimer();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(score: _score, totalQuestions: widget.questions.length),
        ),
      );
    }
  }

  void _answerQuestion(String selectedAnswer) {
    if (_isAnswered) return;
    setState(() {
      _isAnswered = true;
    });
    _timer?.cancel();
    final correctAnswer = widget.questions[_currentQuestionIndex].correctAnswer;
    int score = selectedAnswer == correctAnswer ? 1 : 0;
    Future.delayed(const Duration(seconds: 1), () => _nextQuestion(score));
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Question ${_currentQuestionIndex + 1}/${widget.questions.length}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    '$_timeLeft s',textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    question.question,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ...question.options.map((option) => SizedBox(
                    width: double.infinity,
                    child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ElevatedButton(
                            onPressed: () => _answerQuestion(option),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isAnswered
                                  ? (option == question.correctAnswer ? Colors.green : Colors.red)
                                  : Colors.blue,
                            ),
                            child: Text(option, style: const TextStyle(fontSize: 16)),
                          ),
                        ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}