import 'package:flutter/material.dart';

void main() {
  runApp(const FlashcardsApp());
}

class FlashcardsApp extends StatelessWidget {
  const FlashcardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcards App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const FlashcardsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Flashcard {
  final String question;
  final String answer;

  Flashcard({required this.question, required this.answer});
}

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  final List<Flashcard> _flashcards = [
    Flashcard(question: "What is Flutter?", answer: "An open-source UI toolkit."),
    Flashcard(question: "Who developed Flutter?", answer: "Google."),
  ];

  int _currentIndex = 0;
  bool _showAnswer = false;

  final TextEditingController _qController = TextEditingController();
  final TextEditingController _aController = TextEditingController();

  void _flipCard() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  void _nextCard() {
    setState(() {
      _showAnswer = false;
      _currentIndex = (_currentIndex + 1) % _flashcards.length;
    });
  }

  void _addFlashcard() {
    if (_qController.text.isNotEmpty && _aController.text.isNotEmpty) {
      setState(() {
        _flashcards.add(
          Flashcard(
            question: _qController.text,
            answer: _aController.text,
          ),
        );
      });
      _qController.clear();
      _aController.clear();
      Navigator.pop(context);
    }
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Flashcard"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _qController,
              decoration: const InputDecoration(labelText: "Question"),
            ),
            TextField(
              controller: _aController,
              decoration: const InputDecoration(labelText: "Answer"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: _addFlashcard,
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flashcard = _flashcards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flashcards"),
        centerTitle: true,
      ),
      body: Center(
        child: GestureDetector(
          onTap: _flipCard,
          child: Card(
            elevation: 6,
            color: Colors.blue[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              width: 300,
              height: 200,
              child: Center(
                child: Text(
                  _showAnswer ? flashcard.answer : flashcard.question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "add",
            onPressed: _showAddDialog,
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: "next",
            onPressed: _nextCard,
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
