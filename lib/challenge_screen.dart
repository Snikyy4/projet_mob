import 'package:flutter/material.dart';
import 'page_defi1.dart'; //import du fichier pour le défi 1
import 'main.dart';
import 'taupes.dart';


class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Défis'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => navigateTo(context, const FlagsScreen()),
              child: const Text('Jeu des drapeaux'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Lequel n'a pas"),
            ),
            ElevatedButton(
              onPressed: () => navigateTo(context, MoleGame()),
              child: Text('Jeu des taupes | Record : $temps_taupe secondes'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Défi 4'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Défi 5'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Défi 6'),
            ),
          ],
        ),
      ),
    );
  }
}