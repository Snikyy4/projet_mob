
import 'package:flutter/material.dart';

class FlagsScreen extends StatelessWidget {
  final List<Flag> _flags = [    Flag(name: 'France', image: 'assets/france.png'),    Flag(name: 'Allemagne', image: 'assets/allemagne.png'),    Flag(name: 'Italie', image: 'assets/italie.png'),    Flag(name: 'Espagne', image: 'assets/espagne.png'),  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jeu des drapeaux'),
      ),
      body: ListView.builder(
        itemCount: _flags.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GuessFlagScreen(flag: _flags[index]),
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                children: [
                  Image.asset(
                    _flags[index].image,
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(width: 10),
                  Text(
                    _flags[index].name,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class GuessFlagScreen extends StatefulWidget {
  final Flag flag;

  GuessFlagScreen({required this.flag});

  @override
  _GuessFlagScreenState createState() => _GuessFlagScreenState();
}

class _GuessFlagScreenState extends State<GuessFlagScreen> {
  String _guess = '';
  bool _correct = false;

  void _checkGuess() {
    if (_guess.toLowerCase() == widget.flag.name.toLowerCase()) {
      setState(() {
        _correct = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Devinez le pays'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Image.asset(
              widget.flag.image,
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _guess = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Entrez le nom du pays',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkGuess,
              child: Text('Valider'),
            ),
            SizedBox(height: 20),
            if (_correct)
              Text(
                'Bravo, vous avez deviné!',
                style: TextStyle(fontSize: 20),
              ),
          ],
        ),
      ),
    );
  }
}

class Flag {
  final String name;
  final String image;

  Flag({required this.name, required this.image});
}