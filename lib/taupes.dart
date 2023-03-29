import 'dart:async';
import 'dart:math';
import 'package:projet_mob/challenge_screen.dart';
import 'package:sqflite/sqflite.dart';

import 'main.dart';
import 'package:flutter/material.dart';

class MoleGame extends StatefulWidget {
  @override
  _MoleGameState createState() => _MoleGameState();
}

class _MoleGameState extends State<MoleGame> {
  int _score = 0;
  late Timer _timer;
  Random _random = Random();
  late List<bool> _moles;
  DateTime startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _moles = List.filled(9, false);
    _startTimer();
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        _showMoles();
      },
    );
  }

  void _showMoles() {
    int index = _random.nextInt(9);
    setState(() {
      _moles[index] = true;
    });
    Future.delayed(const Duration(milliseconds: 750), () {
      if (mounted) {
        setState(() {
          _moles[index] = false;
        });
      }
    });
  }

  void _onTap(int index) {
    if (_moles[index]) {
      setState(() {
        _score++;
        if (_score == 5) {
          _timer.cancel();

          DateTime endTime = DateTime.now();
          Duration totalTime = endTime.difference(startTime); // Durée totale

          double total = totalTime.inSeconds +
              (totalTime.inMilliseconds % 1000) /
                  1000; // Durée totale en secondes et en millisecondes
          if (total < temps_taupe || temps_taupe == -1) {
            // vérifie si c pas la prmeiere fois que l'on joue ou alors que notre nouveau temps est meilleur que celui dans la bdd
            temps_taupe = total;
            updateScore(temps_taupe);
          }
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('FIN'),
                content: Text(
                    'Fin du jeu des taupes ! Vous avez tapé 5 taupes en $total secondes'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(pseudo: nom_user, nbVictoires: nb_victoires, tempsTaupe: temps_taupe)),
                      );
                    },
                  ),
                ],
              );
            },
          );
        }
        _moles[index] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Score: $_score',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 20.0),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: List.generate(9, (index) {
                return GestureDetector(
                  onTap: () => _onTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _moles[index] ? Colors.brown : Colors.green,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> updateScore(double newScore) async {
  Database db = await openDatabase('myapp.db');
  await db.update(
    'Users',
    {'tempsTaupe': newScore},
    where: 'username = ?',
    whereArgs: [nom_user],
  );
}
