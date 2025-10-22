import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

enum Move { rock, paper, scissors }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sasso Carta Forbice',
      theme: ThemeData(
      colorSchemeSeed: Color.fromARGB(255, 13, 134, 23),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Color.fromARGB(255, 0, 255, 0),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: RockPaperScissorsGame(),
    );
  }
}

class RockPaperScissorsGame extends StatefulWidget {
  @override
  _RockPaperScissorsGameState createState() => _RockPaperScissorsGameState();
}

class _RockPaperScissorsGameState extends State<RockPaperScissorsGame> {
  Move? _userMove;
  Move? _pcMove;
  String _result = '';

  Move _randomMove() {
    final moves = Move.values;
    return moves[Random().nextInt(moves.length)];
  }

  void _play(Move userMove) {
    final pcMove = _randomMove();
    String result;

    if (userMove == pcMove) {
      result = 'Parità!';
    } else if (
      (userMove == Move.rock && pcMove == Move.scissors) ||
      (userMove == Move.scissors && pcMove == Move.paper) ||
      (userMove == Move.paper && pcMove == Move.rock)
    ) {
      result = 'Hai vinto!';
    } else {
      result = 'Hai perso!';
    }

    setState(() {
      _userMove = userMove;
      _pcMove = pcMove;
      _result = result;
    });
  }

  Widget _moveButton(Move move, String label) {
    return ElevatedButton(
      onPressed: () => _play(move),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sasso Carta Forbice'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('fai la tua mossa:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _moveButton(Move.rock, 'rock'),
                _moveButton(Move.paper, 'paper'),
                _moveButton(Move.scissors, 'scissors'),
              ],
            ),
            if (_userMove != null && _pcMove != null) ...[
              SizedBox(height: 30),
              Text('Tu hai scelto: ${_userMove.toString().split('.').last}'),
              Text('PC ha scelto: ${_pcMove.toString().split('.').last}'),
              SizedBox(height: 25),
              Text(
                _result,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _userMove = null;
                    _pcMove = null;
                    _result = '';
                  });
                },
                child: Text('Gioca di nuovo'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
