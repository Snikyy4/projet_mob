import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projet_mob/challenge_screen.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MazeGame extends StatefulWidget {
  @override
  _MazeGameState createState() => _MazeGameState();
}

class _MazeGameState extends State<MazeGame> {
  double ballX = 0.0;
  double ballY = 0.0;
  double holeX = 150.0;
  double holeY = 300.0;
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  bool hasWon = false;

  late StreamSubscription accelSub;

  @override
  void initState() {
    super.initState();
    DateTime startTime = DateTime.now();
    accelSub = accelerometerEvents.listen((AccelerometerEvent event) {
      if (hasWon) return; // Don't update ball position if game is won
     setState(() {
  // Invert X and Y values to match screen orientation
  ballY += event.x * 5.0;
  ballX += event.y * 5.0;
  // Keep the ball inside the screen bounds
  if (ballX < 0) {
    ballX = 0;
  }
  if (ballX > screenWidth) {
    ballX = screenWidth;
  }
  if (ballY < 0) {
    ballY = 0;
  }
  if (ballY > screenHeight) {
    ballY = screenHeight;
  }
  // Check if the ball is in the hole
  if (ballX >= holeX - 20 && ballX <= holeX + 20 && ballY >= holeY - 20 && ballY <= holeY + 20) {
    // Set hasWon to true to prevent further updates to ball position
    hasWon = true;
    // Show dialog box with winning message and reset button
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("You Win!"),
          content: Text("You completed the maze in ${DateTime.now().second - startTime.second} seconds."),
          actions: [
           TextButton(
  child: Text("Menu"),
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChallengeScreen()),
    );
  },
),
          ],
        );
      },
    );
  }
});

    });
  }

  @override
  void dispose() {
    accelSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      title: 'Flutter Ball Game',
      home: Scaffold(
        body: Container(
          
          child: CustomPaint(
            painter: BallPainter(
              ballX: ballX,
              ballY: ballY,
              holeX: holeX,
              holeY: holeY,
              hasWon: hasWon,
            ),
          ),
        ),
      ),
    );
  }
}

class BallPainter extends CustomPainter {
  final double ballX;
  final double ballY;
  final double holeX;
  final double holeY;
  final bool hasWon;

  BallPainter({required this.ballX, required this.ballY, required this.holeX, required this.holeY, required this.hasWon});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the hole
    canvas.drawCircle(Offset(holeX, holeY), 20.0, Paint()..color = Colors.black);

    if (hasWon) {
      // Draw the winning text
      final textStyle = TextStyle(
        color: Colors.white,
        fontSize: 50.0,
        fontWeight: FontWeight.bold,
      );
      final textSpan = TextSpan(text: "You Win!", style: textStyle);
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
     
  textPainter.paint(canvas, Offset(size.width / 2 - textPainter.width / 2, size.height / 2 - textPainter.height / 2));
} else {
  // Draw the ball
  canvas.drawCircle(Offset(ballX, ballY), 20.0, Paint()..color = Colors.red);
}
}

@override
bool shouldRepaint(covariant BallPainter oldDelegate) {
return ballX != oldDelegate.ballX || ballY != oldDelegate.ballY || hasWon != oldDelegate.hasWon;
}
}