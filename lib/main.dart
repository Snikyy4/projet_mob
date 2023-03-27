import 'package:flutter/material.dart';
import 'page_defi1.dart'; //import du fichier pour le défi 1

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
      home: const MyHomePage(title: 'LE JEU DE ZINZIN'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => navigateTo(context, const ChallengeScreen()),
                child: const Text('Mode Solo'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Mode Multi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
              onPressed: () => navigateTo(context, FlagsScreen()),
              child: const Text('Défi 1'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Défi 2'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Défi 3'),
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
