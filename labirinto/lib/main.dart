import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const LabirintoApp());
}

class LabirintoApp extends StatelessWidget {
  const LabirintoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LabirintoPage(),
    );
  }
}

class LabirintoPage extends StatefulWidget {
  const LabirintoPage({super.key});

  @override
  State<LabirintoPage> createState() => _LabirintoPageState();
}

class _LabirintoPageState extends State<LabirintoPage> {
  late StreamSubscription accelerometerSubscription;

  double ballX = 200;
  double ballY = 200;
  double velocityX = 0;
  double velocityY = 0;

  final double ballRadius = 15;
  final double friction = 0.98;
  final double sensitivity = 0.4;

@override
void initState() {
  super.initState();

  accelerometerSubscription =
      accelerometerEventStream().listen((event) {
    setState(() {
      velocityX += event.x * sensitivity;
      velocityY += event.y * sensitivity;

      velocityX *= friction;
      velocityY *= friction;

      ballX -= velocityX;
      ballY += velocityY;
    });
  });
}

  void resetGame() {
    setState(() {
      ballX = 200;
      ballY = 200;
      velocityX = 0;
      velocityY = 0;
    });
  }

  @override
  void dispose() {
    accelerometerSubscription.cancel();
    super.dispose();
  }

  bool checkWallCollision(double x, double y) {
    // Muro orizzontale alto
    if (y - ballRadius <= 104 &&
        y + ballRadius >= 96 &&
        x > 50 &&
        x < MediaQuery.of(context).size.width - 50) {
      return true;
    }

    // Muro orizzontale basso
    if (y - ballRadius <= 304 &&
        y + ballRadius >= 296 &&
        x > 50 &&
        x < MediaQuery.of(context).size.width - 50) {
      return true;
    }

    // Muro verticale sinistro
    if (x - ballRadius <= 54 &&
        x + ballRadius >= 46 &&
        y > 100 &&
        y < 300) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: resetGame,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            double nextX = ballX.clamp(ballRadius, width - ballRadius);
            double nextY = ballY.clamp(ballRadius, height - ballRadius);

            if (!checkWallCollision(nextX, nextY)) {
              ballX = nextX;
              ballY = nextY;
            } else {
              velocityX = 0;
              velocityY = 0;
            }

            return CustomPaint(
              size: Size(width, height),
              painter: LabirintoPainter(ballX, ballY, ballRadius),
            );
          },
        ),
      ),
    );
  }
}

class LabirintoPainter extends CustomPainter {
  final double ballX;
  final double ballY;
  final double radius;

  LabirintoPainter(this.ballX, this.ballY, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final wallPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 8;

    final ballPaint = Paint()
      ..color = Colors.blue;

    // Muri
    canvas.drawLine(
        const Offset(50, 100), Offset(size.width - 50, 100), wallPaint);

    canvas.drawLine(
        Offset(50, 300), Offset(size.width - 50, 300), wallPaint);

    canvas.drawLine(
        const Offset(50, 100), const Offset(50, 300), wallPaint);

    // Pallina
    canvas.drawCircle(Offset(ballX, ballY), radius, ballPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}