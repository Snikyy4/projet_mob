import 'package:flutter/material.dart';
import 'package:projet_mob/wifi_direct.dart';
import 'challenge_screen.dart';
import 'database.dart';
import 'wifi_direct.dart';

String nom_user = '';
int nb_victoires = 0;
double temps_taupe = -1;
int scoreAlienRun = -1;
double temps_boussole = -1;
double temps_lab = -1;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RocketLiche',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.pseudo, required this.nbVictoires, required this.tempsTaupe, required this.scoreAlien, required this.tempsBoussole, required this.tempsLab})
      : super(key: key);

  final String pseudo;
  final int nbVictoires;
  final double tempsTaupe;
  final int scoreAlien;
  final double tempsBoussole;
  final double tempsLab;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    nom_user = widget.pseudo;
    nb_victoires = widget.nbVictoires;
    temps_taupe = widget.tempsTaupe;
    scoreAlienRun = widget.scoreAlien;
    temps_boussole = widget.tempsBoussole;
    temps_lab=widget.tempsLab;
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/assets/fond_ecran.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      navigateTo(context, const ChallengeScreen()),
                  child: const Text('Mode Solo'),
                ),
                ElevatedButton(
                  onPressed: () => navigateTo(context, ModeMulti()),
                  child: const Text('Mode Multi'),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.1,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                child: Text(
                  '$nom_user | $nb_victoires victoire(s)',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 0.05, // la taille de la police en fonction de la taille de l'écran
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ).copyWith(fontSize: MediaQuery.of(context).size.width * 0.05),
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

void navigateTo(BuildContext context, Widget destinationPage) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => destinationPage),
  );
}
