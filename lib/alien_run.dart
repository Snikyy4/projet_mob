import 'dart:async';
import 'dart:math';
import 'package:projet_mob/challenge_screen.dart';
import 'package:sqflite/sqflite.dart';

import 'main.dart';
import 'package:flutter/material.dart';

class AlienRun extends StatefulWidget {
  @override
  _AlienRunState createState() => _AlienRunState();
}

class _AlienRunState extends State<AlienRun> {
  double _playerX = 0.0;
  double _playerY = 0.0;
  late Timer _timer; 
  double _wallY = 0.0;
  double _holeX = 0.0;
  int _score = 0;
  Random _random = Random();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _wallY += 1.0;
        if (_wallY >= MediaQuery.of(context).size.height) {
          _wallY = 0.0;
          _holeX = _random.nextDouble() * MediaQuery.of(context).size.width;
        }
        if (_playerY <= _wallY + 50.0 &&
            _playerX >= _holeX - 50.0 &&
            _playerX <= _holeX + 50.0) {
          _score++;
        } else { //fin du jeu
          scoreAlienRun = _score;
          updateScore(scoreAlienRun);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('FIN'),
                content: Text(
                    'Fin du jeu ! Vous avez obtenu un score de $_score'),
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
                                scoreAlien:  scoreAlienRun,)),
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
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('My Game'),
      // ),
      body: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          setState(() {
            _playerX += details.delta.dx;
          });
        },
        child: Stack(
          children: [
            Positioned(
              left: _playerX,
              top: _playerY,
              child: Image.asset('assets/vaisseau.png'),
            ),
            Positioned(
              left: _holeX,
              top: _wallY,
              child: Image.asset('assets/trou_noir.png'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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