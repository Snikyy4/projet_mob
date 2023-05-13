import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:projet_mob/challenge_screen.dart';
import 'package:projet_mob/finMultijoueur.dart';
import 'package:projet_mob/wifi_direct.dart';
import 'package:sqflite/sqflite.dart';

import 'wifi_direct.dart';
import 'main.dart';

class AlienRun extends StatefulWidget {
  final bool isMultiplayer;
  final bool? isPlayerOne;

  const AlienRun({Key? key, required this.isMultiplayer, this.isPlayerOne})
      : super(key: key);

  @override
  _AlienRunState createState() => _AlienRunState();
}

class _AlienRunState extends State<AlienRun> {
  final double _blockSize = 50.0;
  double _playerX = 0.0;
  double _playerY = 0.0;
  double _blockY = 0.0;
  double _blockX = 0.0;
  int _score = 0;
  bool _end = false;
  Timer? _timer;
  int _blockSpeedMultiplier = 1;

  DateTime startTime = DateTime.now();
  int timeRemaining = 30;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _playerX = MediaQuery.of(context).size.width / 2 -
          25; // 25 = half the width of the image
      _playerY = MediaQuery.of(context).size.height - 110;
    });

    // Start the game loop
    _timer = Timer.periodic(const Duration(milliseconds: 5), (timer) {
      setState(() {
        // Move the block down the screen
        _blockY += 1 * _blockSpeedMultiplier;

        // Check if the block has reached the bottom of the screen
        if (_blockY > MediaQuery.of(context).size.height) {
          spawnBlock();
        }

        // Check if the player has collided with the block
        if (_playerX + 25 >= _blockX &&
            _playerX + 25 <= _blockX + _blockSize &&
            _playerY + 50 >= _blockY &&
            _playerY <= _blockY + _blockSize) {
          _score++;
          spawnBlock();
        }

        // Check if the game has ended
        if (DateTime.now().difference(startTime).inSeconds >= 30) {
          _end = true;
          timer.cancel();
          if (!widget.isMultiplayer) {
            // Mode solo
            if (_score > scoreAlienRun || _score == -1) {
              // Check if it's the first time playing or if the new score is better than the one in the database
              scoreAlienRun = _score;
              updateScore(scoreAlienRun);
            }

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('FIN'),
                  content:
                      Text('Fin du jeu ! Vous avez obtenu un score de $_score'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () async {
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
          } else {
            // Mode Multi
            if (_score > scoreAlienRun || _score == -1) {
              // Check if it's the first time playing or if the new score is better than the one in the database
              scoreAlienRun = _score;
              updateScore(scoreAlienRun);
            }

            if (widget.isPlayerOne!) {
              // Joueur 1
              alienRun1 = _score;
              sendMessage("AR1/$alienRun1");
              showDia(_score, true);
            } else {
              // Joueur 2
              alienRun2 = _score;
              sendMessage("AR2/$alienRun2");
              showDia(_score, false);
            }
          }
        }
      });
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_end) {
        setState(() {
          if (timeRemaining > 0) {
            timeRemaining--;
          }
        });
      } else {
        timer.cancel();
      }
    });

    // Increase the speed of the blocks every 3 seconds
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_end) {
        setState(() {
          _blockSpeedMultiplier++;
        });
      } else {
        timer.cancel();
      }
    });
  }


  void showDia(int score, bool who) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('FIN'),
          content: Text('Fin du jeu ! Vous avez obtenu un score de $score'),
          actions: <Widget>[

            TextButton(
              child: const Text('Résultat'),
              onPressed: () async {
                navigateTo(context, FinMultijoueur());
              },
            ),
        ],
        );
      },
    );
  }

  void spawnBlock() {
    _blockX = Random()
        .nextInt(MediaQuery.of(context).size.width.toInt() - _blockSize.toInt())
        .toDouble();
    _blockY = -_blockSize;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/alienrun.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: _playerX,
              top: _playerY,
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    _playerX += details.delta.dx;
                  });
                },
                child: Image.asset(
                  'lib/assets/vaisseau.png',
                  width: 75,
                  height: 75,
                ),
              ),
            ),
            Positioned(
              left: _blockX,
              top: _blockY,
              child: Image.asset(
                'lib/assets/trou_noir.png',
                width: 50,
                height: 50,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                    ),
                    child: Text(
                      'Temps restant: $timeRemaining secondes',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                    ),
                    child: Text(
                      'Score: $_score',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> updateScore(int newScore) async {
  Database db = await openDatabase('myapp.db');
  await db.update(
    'Users',
    {'scoreAlienRun': newScore},
    where: 'username = ?',
    whereArgs: [nom_user],
  );
}
