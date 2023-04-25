import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projet_mob/main.dart';
import 'challenge_screen.dart';

class FlagsScreen extends StatefulWidget {
  const FlagsScreen({Key? key}) : super(key: key);

  @override
  _FlagsScreenState createState() => _FlagsScreenState();
}

class _FlagsScreenState extends State<FlagsScreen> {
  final List<Flag> _flags = [
    Flag(name: 'France', image: 'lib/assets/pays/france.png'),
    Flag(name: 'Allemagne', image: 'lib/assets/pays/allemagne.png'),
    Flag(name: 'Italie', image: 'lib/assets/pays/italie.png'),
    Flag(name: 'Espagne', image: 'lib/assets/pays/espagne.png'),
    Flag(name: 'Royaume unis', image: 'lib/assets/pays/angleterre.png'),
    Flag(name: 'Argentine', image: 'lib/assets/pays/argentine.png'),
    Flag(name: 'Australie', image: 'lib/assets/pays/australie.png'),
    Flag(name: 'autriche', image: 'lib/assets/pays/autriche.png'),
    Flag(name: 'belgique', image: 'lib/assets/pays/belgique.png'),
    Flag(name: 'bolivie', image: 'lib/assets/pays/bolivie.png'),
    Flag(name: 'bresil', image: 'lib/assets/pays/bresil.png'),
    Flag(name: 'chili', image: 'lib/assets/pays/chili.png'),
    Flag(name: 'chine', image: 'lib/assets/pays/chine.png'),
    Flag(name: 'colombie', image: 'lib/assets/pays/colombie.png'),
    Flag(name: 'costa rica', image: 'lib/assets/pays/costa_rica.png'),
    Flag(name: 'croatie', image: 'lib/assets/pays/croatie.png'),
    Flag(name: 'finlande', image: 'lib/assets/pays/finlande.png'),
    Flag(name: 'hongrie', image: 'lib/assets/pays/hongrie.png'),
    Flag(name: 'inde', image: 'lib/assets/pays/inde.png'),
    Flag(name: 'irlande', image: 'lib/assets/pays/irlande.png'),
    Flag(name: 'kazakhstan', image: 'lib/assets/pays/kazakhstan.png'),
    Flag(name: 'luxembourg', image: 'lib/assets/pays/luxembourg.png'),
    Flag(name: 'mexique', image: 'lib/assets/pays/mexique.png'),
    Flag(name: 'norvege', image: 'lib/assets/pays/norvege.png'),
    Flag(name: 'pays bas', image: 'lib/assets/pays/pays_bas.png'),
     Flag(name: 'perou', image: 'lib/assets/pays/perou.png'),
    Flag(name: 'pologne', image: 'lib/assets/pays/pologne.png'),
    Flag(name: 'portugal', image: 'lib/assets/pays/portugal.png'),
    Flag(name: 'roumanie', image: 'lib/assets/pays/roumanie.png'),
    Flag(name: 'russie', image: 'lib/assets/pays/russie.png'),
    Flag(name: 'suede', image: 'lib/assets/pays/suede.png'),
    
    Flag(name: 'tunisie', image: 'lib/assets/pays/tunisie.png'),
    Flag(name: 'turquie', image: 'lib/assets/pays/turquie.png'),
    Flag(name: 'ukraine', image: 'lib/assets/pays/ukraine.png'),
    Flag(name: 'uruguay', image: 'lib/assets/pays/uruguay.png'),
    Flag(name: 'venezuela', image: 'lib/assets/pays/venezuela.png'),
   
    // Ajouter d'autres pays ici si nécessaire
  ];

  final int _numFlags = 5; // Nombre de drapeaux à deviner

  Flag? _currentFlag;
  String _inputValue = '';
  Set<Flag> _usedFlags = {};

  List<Flag> _selectFlags() {
    // Sélectionne _numFlags drapeaux aléatoirement parmi _flags
    List<Flag> selectedFlags = [];
    List<Flag> unusedFlags = List.from(_flags);
    Random random = Random();

    for (int i = 0; i < _numFlags; i++) {
      int index = random.nextInt(unusedFlags.length);
      selectedFlags.add(unusedFlags.removeAt(index));
    }

    return selectedFlags;
  }

  @override
  void initState() {
    super.initState();
    List<Flag> selectedFlags = _selectFlags();
    _currentFlag = selectedFlags[0];
    _flags.retainWhere((flag) => selectedFlags.contains(flag));
  }

 int _numCorrectAnswers = 0; // Nombre de réponses correctes

void _onGuess(String guess) {
  if (_currentFlag != null && guess.toLowerCase() == _currentFlag!.name.toLowerCase()) {
    final oldFlagName = _currentFlag!.name;
    _usedFlags.add(_currentFlag!);
    _numCorrectAnswers++; // Incrémenter le nombre de réponses correctes
    setState(() {
      if (_usedFlags.length == _numFlags) {
        _usedFlags.clear();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Fin du jeu!'),
              content: Text('Vous avez terminé le jeu avec $_numCorrectAnswers réponses correctes sur $_numFlags.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    navigateTo(context, MyHomePage(pseudo: nom_user, nbVictoires: nb_victoires, tempsTaupe: temps_taupe));
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        int randomIndex;
        do {
          randomIndex = Random().nextInt(_flags.length);
        } while (_usedFlags.contains(_flags[randomIndex]));
        _currentFlag = _flags[randomIndex];
        _inputValue = '';
      }
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bravo!'),
          content: Text('Vous avez deviné le drapeau $oldFlagName.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Continuer'),
            ),
          ],
        );
      },
    );
  } else {
    _usedFlags.add(_currentFlag!);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('BOUHHH!'),
          content: Text('Vous vous êtes trompés .'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Continuer'),
            ),
          ],
        );
      },
    );
    if (_usedFlags.length == _numFlags) {
      _usedFlags.clear();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Fin du jeu!'),
            content: Text('Vous avez terminé le jeu avec $_numCorrectAnswers réponses correctes sur $_numFlags.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  navigateTo(context, MyHomePage(pseudo: nom_user, nbVictoires: nb_victoires, tempsTaupe: temps_taupe));
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        int randomIndex;
        do {
          randomIndex = Random().nextInt(_flags.length);
        } while (_usedFlags.contains(_flags[randomIndex]));
        _currentFlag = _flags[randomIndex];
        _inputValue = '';
      });
    }
  }
}

void _validateGuess() {
  if (_inputValue.isNotEmpty) {
    _onGuess(_inputValue);
  }
}



  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Jeu des drapeaux'),
    ),
    body: Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            _currentFlag!.image,
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 20),
          TextField(
            onChanged: (value) {
              _inputValue = value;
            },
            onSubmitted: _onGuess,
            decoration: const InputDecoration(
              hintText: 'Entrez le nom du pays',
            ),
            controller: TextEditingController(text: _inputValue),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _onGuess(_inputValue);
            },
            child: const Text('Valider'),
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
