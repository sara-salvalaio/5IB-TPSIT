import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: "Quiz Game",
    initialRoute: '/',
    routes: {
      '/': (context) => const HomeRoute(),
      '/quiz': (context) => const QuizRoute(),
      '/result': (context) => const ResultRoute(),
    },
  ));
}

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz Game")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Inizia Quiz"),
          onPressed: () {
            Navigator.pushNamed(context, '/quiz');
          },
        ),
      ),
    );
  }
}

class QuizRoute extends StatefulWidget {
  const QuizRoute({super.key});

  @override
  State<QuizRoute> createState() => _QuizRouteState();
}

class _QuizRouteState extends State<QuizRoute> {
  List<dynamic> questions = [];
  int currentIndex = 0;
  int score = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  /// Carica le domande da OpenTriviaDB
  Future<void> fetchQuestions() async {
    final response = await http
        .get(Uri.parse("https://opentdb.com/api.php?amount=10&type=multiple"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        questions = data["results"];
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = questions[currentIndex];
    final correctAnswer = question["correct_answer"];
    final List<String> answers = [...question["incorrect_answers"], correctAnswer]
      ..shuffle();

    return Scaffold(
      appBar: AppBar(title: Text("Domanda ${currentIndex + 1}/10")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question["question"],
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),

            /// Opzioni di risposta
            ...answers.map((ans) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (ans == correctAnswer) {
                      score++;
                    }

                    if (currentIndex < 9) {
                      setState(() => currentIndex++);
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        '/result',
                        arguments: score,
                      );
                    }
                  },
                  child: Text(ans),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

class ResultRoute extends StatelessWidget {
  const ResultRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final int score = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(title: const Text("Risultato Finale")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Punteggio: $score / 10",
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Rigioca"),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/quiz');
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text("Torna alla Home"),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            )
          ],
        ),
      ),
    );
  }
}
