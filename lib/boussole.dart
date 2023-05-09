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
  final double _marginOfError = 2.0;
  

  @override
  void initState() {
    super.initState();
    _startListeningMagnetometer();
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
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('FIN'),
                  content: const Text(
                      'Fin du jeu ! Vous avez atteint la direction souhaitée'),
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
    body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/assets/boussole.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pointez vers: ${_randomDirection.toStringAsFixed(2)}°',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Direction actuelle: ${_direction.toStringAsFixed(2)}°',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Transform.rotate(
              angle: (_direction - _randomDirection) * pi / 180,
              child: Image.asset(
                'lib/assets/vaisseau.png',
                width: 100,
                height: 100,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}
