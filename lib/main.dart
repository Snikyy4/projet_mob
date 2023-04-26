import 'package:flutter/material.dart';
import 'challenge_screen.dart';
import 'database.dart';

String nom_user = '';
int nb_victoires = 0;
double temps_taupe = -1;
int scoreAlienRun = -1;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.pseudo, required this.nbVictoires, required this.tempsTaupe, required this.scoreAlien})
      : super(key: key);

  final String pseudo;
  final int nbVictoires;
  final double tempsTaupe;
  final int scoreAlien;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String pseudo = '';
  int nbVictoires = 0;
  double tempsTaupe = -1;
  @override
  void initState() {
    super.initState();
    nom_user = widget.pseudo;
    nb_victoires = widget.nbVictoires;
    temps_taupe = widget.tempsTaupe;
    scoreAlienRun = widget.scoreAlien;

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
                    onPressed: () {},
                    child: const Text('Mode Multi'),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(70.0),
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
                      fontSize: 20, // la taille de la police en pixels
                      fontWeight:
                          FontWeight.bold, // le poids de la police (en gras)
                      color: Colors.white, // la couleur du texte
                    ),
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
