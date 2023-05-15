import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'main.dart';
import 'wifi_direct.dart';
import 'package:audioplayers/audioplayers.dart';


class FinMultijoueur extends StatelessWidget {
  bool? isPlayerOne;
  FinMultijoueur( {Key? key,this.isPlayerOne}) : super(key: key);

  int cptJoueur1 = 0;
  int cptJoueur2 = 0;
  String winner = '';
  AudioPlayer audioPlayer = AudioPlayer();
  String url = 'https://www.youtube.com/watch?v=rBc-mKOKXKY';




  String determinerGagnant() {
    audioPlayer.setUrl(url);
    if (taupe1 < taupe2) {
      cptJoueur1++;
    } else if (taupe1 > taupe2) {
      cptJoueur2++;
    }

    if (alienRun1 < alienRun2) {
      cptJoueur2++;
    } else if (alienRun1 > alienRun2) {
      cptJoueur1++;
    }

    if (cptJoueur1 > cptJoueur2) {
      if (nom_user == nomJ1 && isPlayerOne==true) {
        nb_victoires++;
        winner=nomJ1;
        updateScore(nb_victoires);
        sendMessage('1/WIN');
        //Jouer victoire
        audioPlayer.play(url);
      }

      return "$nomJ1 gagne !";
    } else if (cptJoueur1 < cptJoueur2) {
      if (nom_user == nomJ2  && isPlayerOne==false) {
        nb_victoires++;
        winner=nomJ2;
        updateScore(nb_victoires);
        //Jouer victoire
        sendMessage("2/WIN");
        audioPlayer.play(url);
      }

      return "$nomJ2 gagne !";
    } else {
      return "Égalité";
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Résultats"),
        automaticallyImplyLeading: false, // Désactiver le bouton de retour
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          nomJ1,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Score Jeu des Taupes : ${taupe1.toStringAsFixed(2)} sec",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Score Jeu Alien Run : ${alienRun1.toStringAsFixed(2)} points",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          nomJ2,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Score Jeu des Taupes : ${taupe2.toStringAsFixed(2)} sec",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Score Jeu Alien Run : ${alienRun2.toStringAsFixed(2)} points",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              determinerGagnant(),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
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
                      tempsLab: temps_lab,
                    ),
                  ),
                );
              },
              child: const Text("Menu principal"),
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
    {'nbVictoires': newScore},
    where: 'username = ?',
    whereArgs: [nom_user],
  );
}
