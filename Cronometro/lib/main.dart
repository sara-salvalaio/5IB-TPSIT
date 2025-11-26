import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: StopwatchPage(),
        debugShowCheckedModeBanner: false,
      );
}

class StopwatchPage extends StatefulWidget {
  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  int ticks = 0;
  int seconds = 0;

  StreamSubscription<int>? subTick;
  StreamSubscription<int>? subSec;

  bool running = false;
  bool paused = false;

  /// Stream che genera un tick ogni 100 ms
  Stream<int> get tickStream =>
      Stream.periodic(const Duration(milliseconds: 100), (n) => n);

  /// Stream dei secondi derivato dai tick
  Stream<int> get secondStream =>
      tickStream.where((t) => t % 10 == 0).map((t) => t ~/ 10);

  void start() {
    ticks = 0;
    seconds = 0;
    running = true;
    paused = false;

    subTick = tickStream.listen((t) {
      if (!paused) setState(() => ticks = t);
    });

    subSec = secondStream.listen((s) {
      if (!paused) setState(() => seconds = s);
    });

    setState(() {});
  }

  void stop() {
    subTick?.cancel();
    subSec?.cancel();
    running = false;
    paused = false;
    setState(() {});
  }

  void reset() {
    ticks = 0;
    seconds = 0;
    setState(() {});
  }

  void togglePause() {
    paused = !paused;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String time = "${(seconds ~/ 60).toString().padLeft(2, '0')}:"
                   "${(seconds % 60).toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(title: const Text("Cronometro semplice")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // DISPLAY TEMPO
            Text(time, style: const TextStyle(fontSize: 70)),

            const SizedBox(height: 40),

            // BOTTONI AL CENTRO
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (!running) start();
                    else stop();
                  },
                  child: Text(running ? "STOP" : "START"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: running ? togglePause : null,
                  child: Text(paused ? "RESUME" : "PAUSE"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: running ? reset : null,
                  child: const Text("RESET"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    subTick?.cancel();
    subSec?.cancel();
    super.dispose();
  }
}