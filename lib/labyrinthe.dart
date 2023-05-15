import 'package:flutter/material.dart';
import 'package:projet_mob/challenge_screen.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import 'dart:async';
import 'main.dart';

class MazeGame extends StatefulWidget {
  @override
  _MazeGameState createState() => _MazeGameState();
}

class _MazeGameState extends State<MazeGame> {
  double ballX = 200.0;
  double ballY = 20.0;
  List<Offset> holes = [];
  double screenWidth = 100;
  double screenHeight = 100;
  bool hasWon = false;
  DateTime? startTime;
    int holeCount = 0;


  late StreamSubscription accelSub;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
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

//regarde si la balle est dans le troue
        for (int i = 0; i < holes.length; i++) {
          Offset hole = holes[i];
          if (ballX >= hole.dx - 10 &&
              ballX <= hole.dx + 10 &&
              ballY >= hole.dy - 10 &&
              ballY <= hole.dy + 10) {
            // Remove the hole from the list
            holes.removeAt(i);

            holeCount++;
// on regare si le joueur a atteitn les 5 trous            
            if (holes.isEmpty && holeCount>=5) {
              hasWon = true;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                        "You completed the maze in ${DateTime.now().second - startTime!.second} seconds."),
                    actions: [
                      TextButton(
                        child: Text("Menu principal"),
                        onPressed: () {
                          Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                    pseudo: nom_user,
                                    nbVictoires: nb_victoires,
                                    tempsTaupe: temps_taupe,
                                    scoreAlien: scoreAlienRun,
                                    tempsBoussole: temps_boussole,
                                  )),
                        );
                        },
                      ),
                    ],
                  );
                },
              );
            }
            break;
          }
        }
      });
    });
    // Generate the initial holes
    
  }

  @override
  void dispose() {
    accelSub.cancel();
    super.dispose();
  }

    void generateHole() {
    Random random = Random();
    double x = random.nextDouble() * screenWidth;
    double y = random.nextDouble() * screenHeight;
    holes = [Offset(x, y)]; // Remplace les trous existants par le nouveau trou
  }
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
     if (holes.isEmpty && holeCount <5) {
      generateHole();
     
    }

    return MaterialApp(
      title: 'Flutter Ball Game',
      home: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'lib/assets/espace.png',
              fit: BoxFit.cover,
              width: screenWidth,
              height: screenHeight,
            ),
            CustomPaint(
              painter: BallPainter(
                ballX: ballX,
                ballY: ballY,
                holes: holes,
                hasWon: hasWon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BallPainter extends CustomPainter {
  final double ballX;
  final double ballY;
  final List<Offset> holes;
  final bool hasWon;

  BallPainter({required this.ballX, required this.ballY, required this.holes, required this.hasWon});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the holes
    for (Offset hole in holes) {
      canvas.drawCircle(hole, 20.0, Paint()..color = Color.fromARGB(255, 229, 221, 221));
    }

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

      textPainter.paint(
          canvas, Offset(size.width / 2 - textPainter.width / 2, size.height / 2 - textPainter.height / 2));
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
