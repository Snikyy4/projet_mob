// ignore_for_file: unnecessary_const, prefer_final_fields

import 'dart:async';
import 'dart:math';
import 'package:projet_mob/alien_run.dart';
import 'package:projet_mob/challenge_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'wifi_direct.dart';

class MoleGame extends StatefulWidget {
  final bool isMultiplayer;
  final bool? isPlayerOne;

  const MoleGame({Key? key, required this.isMultiplayer, this.isPlayerOne})
      : super(key: key);

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
          if (!widget.isMultiplayer) {
            //Mode solo
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
                      'Fin du jeu ! Vous avez tué 5 aliens en $total secondes'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Menu principal'),
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
                                    tempsLab: temps_lab,
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
            
            if (total < temps_taupe || temps_taupe == -1) {
              // vérifie si c pas la prmeiere fois que l'on joue ou alors que notre nouveau temps est meilleur que celui dans la bdd
              temps_taupe = total;
              updateScore(temps_taupe);
            }
            if (widget.isPlayerOne!) {
              taupe1 = total;
              sendMessage("T1/$taupe1");
              showDia(total, true);
            } else {
              taupe2 = total;
              sendMessage("T2/$taupe2");
              showDia(total, false);
            }
          }
        }
        _moles[index] = false;
      });
    }
  }

  void showDia(double total, bool who) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('FIN'),
          content:
              Text('Fin du jeu ! Vous avez tué 5 aliens en $total secondes'),
          actions: <Widget>[
            TextButton(
              child: const Text('Jeu suivant'),
              onPressed: () async {
                navigateTo(
                    context,
                    AlienRun(
                      isMultiplayer: true,
                      isPlayerOne: who,
                    ));
              },
            ),
          ],
        );
      },
    );
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
              "Nombre d'aliens tués : $_score",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
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
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: AssetImage(
                          _moles[index]
                              ? 'lib/assets/alien.png'
                              : 'lib/assets/planete.png',
                        ),
                        fit: BoxFit.cover,
                      ),
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
