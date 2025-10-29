import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mastermind Semplificato',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MastermindGame(),
    );
  }
}

class MastermindGame extends StatefulWidget {
  @override
  _MastermindGameState createState() => _MastermindGameState();
}

class _MastermindGameState extends State<MastermindGame> {
  final List<Color> availableColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple
  ];

  late List<Color> secretCode;
  List<Color> playerCode = [Colors.grey, Colors.grey, Colors.grey, Colors.grey];

  // Lista dei tentativi e dei relativi feedback
  List<List<Color>> guesses = [];
  List<List<String>> feedbacks = [];

  int maxAttempts = 6;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    secretCode = generateSecretCode();
    playerCode = [Colors.grey, Colors.grey, Colors.grey, Colors.grey];
    guesses.clear();
    feedbacks.clear();
  }

  List<Color> generateSecretCode() {
    final random = Random();
    List<Color> secret = [];
    for (int i = 0; i < 4; i++) {
      secret.add(availableColors[random.nextInt(availableColors.length)]);
    }
    return secret;
  }

  void changeColor(int index) {
    if (guesses.length >= maxAttempts) return; // blocca se finiti tentativi
    int currentIndex = availableColors.indexOf(playerCode[index]);
    int nextIndex = (currentIndex + 1) % availableColors.length;
    setState(() {
      playerCode[index] = availableColors[nextIndex];
    });
  }

  // Funzione per calcolare il feedback
  // Ritorna una lista di stringhe: "black" (colore giusto, posto giusto), "white" (colore giusto, posto sbagliato)
  List<String> getFeedback(List<Color> guess, List<Color> secret) {
    List<String> feedback = [];

    // Copie per non modificare originali
    List<Color?> secretCopy = List<Color?>.from(secret);
    List<Color?> guessCopy = List<Color?>.from(guess);

    // 1) Trova i "neri": colore e posizione giusti
    for (int i = 0; i < guessCopy.length; i++) {
      if (guessCopy[i] == secretCopy[i]) {
        feedback.add('black');
        // Segna come "usato"
        secretCopy[i] = null;
        guessCopy[i] = null;
      }
    }

    // 2) Trova i "bianchi": colore giusto posto sbagliato
    for (int i = 0; i < guessCopy.length; i++) {
      if (guessCopy[i] != null) {
        int foundIndex = secretCopy.indexOf(guessCopy[i]);
        if (foundIndex != -1) {
          feedback.add('white');
          secretCopy[foundIndex] = null;
          guessCopy[i] = null;
        }
      }
    }

    // Nota: la lista feedback contiene solo "black" e "white" per ogni pezzo corretto
    // I pezzi errati non hanno segnalazione (per semplificare)
    return feedback;
  }

  void checkCode() {
    if (guesses.length >= maxAttempts) {
      // Se finiti i tentativi, blocca
      return;
    }

    if (playerCode.contains(Colors.grey)) {
      // Non tutti i colori scelti
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seleziona tutti i colori prima di verificare')),
      );
      return;
    }

    List<String> currentFeedback = getFeedback(playerCode, secretCode);

    setState(() {
      guesses.add(List<Color>.from(playerCode));
      feedbacks.add(currentFeedback);
    });

    bool isCorrect = currentFeedback.length == 4 && currentFeedback.every((f) => f == 'black');

    if (isCorrect) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Congratulazioni!'),
          content: Text('Hai indovinato la sequenza!'),
          actions: [
            TextButton(
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
              child: Text('Nuova Partita'),
            ),
          ],
        ),
      );
    } else if (guesses.length >= maxAttempts) {
      // Game over
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Game Over'),
          content: Text('Hai esaurito i tentativi.\nLa sequenza era:\n' +
              secretCode
                  .map((c) => colorName(c))
                  .join(', ')),
          actions: [
            TextButton(
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
              child: Text('Riprova'),
            ),
          ],
        ),
      );
    }

    // Resetta la sequenza giocata (per nuovo tentativo)
    setState(() {
      playerCode = [Colors.grey, Colors.grey, Colors.grey, Colors.grey];
    });
  }

  String colorName(Color color) {
    if (color == Colors.red) return 'Rosso';
    if (color == Colors.blue) return 'Blu';
    if (color == Colors.green) return 'Verde';
    if (color == Colors.yellow) return 'Giallo';
    if (color == Colors.orange) return 'Arancione';
    if (color == Colors.purple) return 'Viola';
    return 'Grigio';
  }

  Widget buildGuessRow(List<Color> guess, List<String> feedback) {
    // Visualizza i 4 colori e 4 indicatori feedback (neri/bianco)
    List<Widget> colorCircles = guess
        .map((c) => Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: Colors.black)),
            ))
        .toList();

    // Indicatori feedback neri e bianchi
    // Per chiarezza visualizziamo i puntini neri e bianchi a parte
    List<Widget> feedbackDots = [];

    // Conta neri e bianchi
    int blackCount = feedback.where((f) => f == 'black').length;
    int whiteCount = feedback.where((f) => f == 'white').length;

    for (int i = 0; i < blackCount; i++) {
      feedbackDots.add(Container(
        margin: EdgeInsets.all(2),
        width: 15,
        height: 15,
        decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
      ));
    }
    for (int i = 0; i < whiteCount; i++) {
      feedbackDots.add(Container(
        margin: EdgeInsets.all(2),
        width: 15,
        height: 15,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.black)),
      ));
    }

    // Riempi il resto fino a 4 con puntini grigi (assenza)
    int emptyCount = 4 - blackCount - whiteCount;
    for (int i = 0; i < emptyCount; i++) {
      feedbackDots.add(Container(
        margin: EdgeInsets.all(2),
        width: 15,
        height: 15,
        decoration: BoxDecoration(color: Colors.grey.shade400, shape: BoxShape.circle),
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...colorCircles,
          SizedBox(width: 20),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: feedbackDots,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mastermind Semplificato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Visualizzazione tentativi precedenti
            Expanded(
              child: guesses.isEmpty
                  ? Center(child: Text('Inserisci la sequenza e premi Verifica'))
                  : ListView.builder(
                      itemCount: guesses.length,
                      itemBuilder: (context, index) {
                        return buildGuessRow(guesses[index], feedbacks[index]);
                      },
                    ),
            ),

            Divider(),

            // Selettore colori attuale
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return GestureDetector(
                  onTap: () => changeColor(index),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: playerCode[index],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: checkCode,
              child: Text('Verifica'),
            ),

            SizedBox(height: 10),

            Text('Tentativi: ${guesses.length} / $maxAttempts'),
          ],
        ),
      ),
    );
  }
}
