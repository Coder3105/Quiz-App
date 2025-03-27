import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _scores = [];

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    var box = await Hive.openBox('quizScores');
    setState(() {
      _scores = List<Map<String, dynamic>>.from(box.get('scores', defaultValue: []));
      _scores.sort((a, b) => b['timestamp'].compareTo(a['timestamp'])); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 89, 97, 100),
        appBar: AppBar(title: Center(child: const Text('Quiz History')),backgroundColor: Colors.blue,),
        body: _scores.isEmpty
            ? const Center(child: Text('No quiz history found'))
            : ListView.builder(
                itemCount: _scores.length,
                itemBuilder: (context, index) {
                  final score = _scores[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text('Score: ${score['score']} / ${score['total']}'),
                      subtitle: Text('Date: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(score['timestamp']))}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
