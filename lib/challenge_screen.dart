// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'page_defi1.dart'; //import du fichier pour le défi 1
import 'main.dart';
import 'taupes.dart';
import 'quinapas.dart';
import 'alien_run.dart';
import 'labyrinthe.dart';
import 'boussole.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({Key? key});

  @override
Widget build(BuildContext context) {
  return Scaffold(
     extendBodyBehindAppBar: true, // étend le corps derrière la barre
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.orange),
      ),
    body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/fond_ecran_chall.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => navigateTo(context, const FlagsScreen()),
              child: const Text('Jeu des drapeaux', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => navigateTo(context, const LequelNAPas()),
              child: const Text("Lequel n'a pas", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => navigateTo(context, const MoleGame(isMultiplayer: false)),
              child: Text("Tape l'alien ! | Record : $temps_taupe secondes", style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => navigateTo(context, const Boussole()),
              child: Text("Find the planet ! | Record : $temps_boussole secondes", style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => navigateTo(context, const AlienRun(isMultiplayer: false,)),
              child: Text("Alien Run | Record : $scoreAlienRun points", style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
             onPressed: () => navigateTo(context, MazeGame()),
              child: const Text('Labyrinthe | Record : -1 secondes', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    ),
  );
}
}
