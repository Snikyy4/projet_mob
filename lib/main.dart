import 'package:flutter/material.dart';
import 'challenge_screen.dart';
import 'database.dart';

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
  const MyHomePage({Key? key, required this.pseudo,required this.nbVictoires}) : super(key: key);

  final String pseudo;
  final String nbVictoires;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String pseudo = '';
  String nbVictoires = '';
  @override
  void initState() {
    super.initState();
    pseudo = widget.pseudo;
    nbVictoires = widget.nbVictoires;
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
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: Text(pseudo + ' | '+nbVictoires + ' victoire(s)'),
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
