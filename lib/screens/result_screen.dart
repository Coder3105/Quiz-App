import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen({super.key, required this.score, required this.totalQuestions});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    _saveScore();
  }

  Future<void> _saveScore() async {
    var box = await Hive.openBox('quizScores');
    List<Map<String, dynamic>> scores = List<Map<String, dynamic>>.from(
        box.get('scores', defaultValue: []));
    
    scores.add({
      'score': widget.score,
      'total': widget.totalQuestions,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await box.put('scores', scores);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Results')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score: ${widget.score} / ${widget.totalQuestions}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Percentage: ${(widget.score / widget.totalQuestions * 100).toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Retry Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
