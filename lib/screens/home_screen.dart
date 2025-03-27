import 'package:flutter/material.dart';
import 'package:quiz_app_test/repository/repository.dart';
import 'package:quiz_app_test/screens/quiz_screen.dart';
import 'package:quiz_app_test/screens/history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuizRepository _quizRepository = QuizRepository();
  String _selectedDifficulty = 'easy';
  String _selectedCategory = 'General Knowledge';
  bool _isLoading = false;

  void _startQuiz() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final questions = await _quizRepository.fetchQuestions(_selectedDifficulty, _selectedCategory);
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(questions: questions),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please retry',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16), 
          duration: const Duration(seconds: 2), 
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 89, 97, 100),
        appBar: AppBar(
          title: Center(child: const Text('Quiz App')), 
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryScreen()),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity, 
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16), 
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 112, 111, 111), 
                        blurRadius: 8,
                        offset: Offset(0, 4), 
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Select Category:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedCategory,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            }
                          },
                          items: ['General Knowledge', 'Science', 'History', 'Sports', 'Movies']
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
              ))
                              .toList(),
                        ),
          ),
        ],
      ),
                ),
                const SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(16), 
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(12), 
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 112, 111, 111), 
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
        child: Column(
                    mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Difficulty:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButton<String>(
                          isExpanded: true,
              value: _selectedDifficulty,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedDifficulty = value;
                  });
                }
              },
              items: ['easy', 'medium', 'hard']
                  .map((level) => DropdownMenuItem(
                        value: level,
                        child: Text(level.toUpperCase()),
                      ))
                  .toList(),
            ),
                      ),
                    ],
            ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, 
                        foregroundColor: Colors.white, 
                      ),
                    onPressed: _startQuiz,
                    child: const Text('Start Quiz'),
                  ),
          ],
            ),
          ),
        ),
      ),
    );
  }
}
