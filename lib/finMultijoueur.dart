import 'package:flutter/material.dart';
import 'main.dart';
import 'wifi_direct.dart';

class FinMultijoueur extends StatelessWidget {


  FinMultijoueur({
    Key? key,
  }) : super(key: key);

  int cptJoueur1 = 0;
  int cptJoueur2 = 0;

  String determinerGagnant() {
    if (taupe1 < taupe2) {
      cptJoueur1++;
    } else if (taupe1  > taupe2) {
      cptJoueur2++;
    }

    if (alienRun1 < alienRun2) {
      cptJoueur2++;
    } else if (alienRun1 > alienRun2) {
      cptJoueur1++;
    }

    if (cptJoueur1 > cptJoueur2) {
      return "Joueur 1 gagne !";
    } else if (cptJoueur1 < cptJoueur2) {
      return "Joueur 2 gagne !";
    } else {
      return "Égalité";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fin du jeu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Score Joueur 1 - Jeu Taupe : ${taupe1.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Text(
              "Score Joueur 2 - Jeu Taupe : ${taupe2.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Text(
              "Score Joueur 1 - Jeu Alien Run : ${alienRun1.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Text(
              "Score Joueur 2 - Jeu Alien Run : ${alienRun2.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 32),
            Text(
              "${determinerGagnant()}",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                          )),
                );
              },
              child: const Text("Retour au menu principal"),
            ),
          ],
        ),
      ),
    );
  }
}
