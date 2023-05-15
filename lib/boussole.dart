import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'main.dart';

class Boussole extends StatefulWidget {
  const Boussole({Key? key}) : super(key: key);

  @override
  _BoussoleState createState() => _BoussoleState();
}

class _BoussoleState extends State<Boussole> {
  late StreamSubscription<MagnetometerEvent> _magnetometerSubscription;
  double _direction = 0;
  final double _randomDirection =
      Random().nextInt(360).toDouble(); // direction aléatoire à pointer
  bool _gameOver = false;
  final double _marginOfError = 0.5;

  DateTime startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startListeningMagnetometer(); // initialiser le temps de début
  }

  @override
  void dispose() {
    _magnetometerSubscription.cancel();
    super.dispose();
  }

  void _startListeningMagnetometer() {
    _magnetometerSubscription =
        magnetometerEvents.listen((MagnetometerEvent event) {
      if (!_gameOver) {
        double direction = atan2(event.y, event.x) * (180 / pi);
        if (direction < 0) {
          direction += 360;
        }

        setState(() {
          _direction = direction;
          if ((_direction - _randomDirection).abs() <= _marginOfError) {
            _gameOver = true;
            _magnetometerSubscription.cancel();
            DateTime endTime = DateTime.now();
            Duration totalTime = endTime.difference(startTime); // Durée totale

            double total = totalTime.inSeconds + (totalTime.inMilliseconds % 1000) / 1000; // Durée totale en secondes et en millisecondes
            if (total < temps_boussole || temps_boussole == -1) {
              // vérifie si c pas la prmeiere fois que l'on joue ou alors que notre nouveau temps est meilleur que celui dans la bdd
              temps_boussole = total;
              updateScore(temps_boussole);
            }
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('FIN'),
                  content: const Text(
                      'Fin du jeu ! Vous avez trouvé la direction de la planète !'),
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
                                    tempsLab: temps_lab,
                                  )),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/boussole.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text(
              'Orientation planète : ${_randomDirection.toStringAsFixed(2)}°',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Direction actuelle: ${_direction.toStringAsFixed(2)}°',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Transform.rotate(
                  angle: (_direction - _randomDirection) * pi / 180,
                  child: Image.asset(
                    'lib/assets/vaisseau.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
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
    {'tempsBoussole': newScore},
    where: 'username = ?',
    whereArgs: [nom_user],
  );
}
