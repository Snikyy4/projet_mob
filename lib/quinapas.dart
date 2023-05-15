import 'dart:math';
import 'package:flutter/material.dart';
import 'main.dart';

class LequelNAPas extends StatefulWidget {
  const LequelNAPas({Key? key}) : super(key: key);

  @override
  _LequelNAPasState createState() => _LequelNAPasState();
}

class _LequelNAPasState extends State<LequelNAPas> {
  late List<Map<String, dynamic>> _questions;
  late int _numQuestions;
  late int _numCorrectAnswers;
  late Set<int> _usedQuestions;
  late String _question;
  late List<String> _propositions;
  late int _reponseIndex;

  @override
  void initState() {
    super.initState();
    _questions = [
      {
        'question': 'Lequel de ces animaux est un mammifère ?',
        'propositions': ['Serpent', 'Grenouille', 'Souris', 'Poisson'],
        'reponseIndex': 2,
      },
      {
        'question': 'Lequel de ces pays ne se trouve pas en Europe ?',
        'propositions': ['France', 'Japon', 'Espagne', 'Russie'],
        'reponseIndex': 1,
      },
      {
        'question': 'Lequel de ces instruments est un instrument à vent ?',
        'propositions': ['Piano', 'Guitare', 'Trompette', 'Batterie'],
        'reponseIndex': 2,
      },
      {
        'question': 'Lequel de ces sports se joue avec une raquette ?',
        'propositions': ['Football', 'Basketball', 'Tennis', 'Baseball'],
        'reponseIndex': 2,
      },
      {
        'question': 'Lequel de ces éléments n\'est pas un métal ?',
        'propositions': ['Fer', 'Cuivre', 'Argent', 'Bois'],
        'reponseIndex': 3,
      },
      {
        'question': 'Lequel de ces fruits est un agrume ?',
        'propositions': ['Pomme', 'Banane', 'Orange', 'Fraise'],
        'reponseIndex': 2,
      },
      {
        'question':
            "Lequel de ces pays n'a pas de frontière avec l'océan Atlantique ?",
        'propositions': ['Brésil', 'Chine', 'Canada', 'Espagne'],
        'reponseIndex': 1,
      },
      {
        'question': 'Lequel de ces personnages de fiction est un super-héros ?',
        'propositions': [
          'Harry Potter',
          'Batman',
          'Sherlock Holmes',
          'Hercule Poirot'
        ],
        'reponseIndex': 1,
      },
      {
        'question': 'Lequel de ces éléments est un gaz ?',
        'propositions': ['Fer', 'Cuivre', 'Argon', 'Plomb'],
        'reponseIndex': 2,
      },
      {
        'question': 'Lequel de ces sports ne se pratique pas sur glace ?',
        'propositions': [
          'Hockey',
          'Patinage artistique',
          'Ski alpin',
          'Curling'
        ],
        'reponseIndex': 2,
      },
      {
        'question': 'Lequel de ces pays ne possède pas de drapeau rouge ?',
        'propositions': ['Chine', 'irlande', 'Japon', 'Italie'],
        'reponseIndex': 1,
      },
      {
        'question':
            'Lequel de ces artistes n\'a jamais remporté de Grammy Award ?',
        'propositions': [
          'Beyoncé',
          'Taylor Swift',
          'Kendrick Lamar',
          'Bruno Mars'
        ],
        'reponseIndex': 2,
      },
      {
        'question': 'Lequel de ces pays ne possède pas de désert ?',
        'propositions': ['Algérie', 'Australie', 'Chine', 'France'],
        'reponseIndex': 3,
      },
      {
        'question':
            'Lequel de ces éléments n\'a pas été découvert par Marie Curie ?',
        'propositions': ['Polonium', 'Radium', 'Uranium', 'Plomb'],
        'reponseIndex': 3,
      },
      {
        'question':
            'Lequel de ces films n\'a pas été réalisé par Quentin Tarantino ?',
        'propositions': [
          'Pulp Fiction',
          'Inglourious Basterds',
          'Kill Bill',
          'The Departed'
        ],
        'reponseIndex': 3,
      },
      {
        'question': 'Lequel de ces animaux n\'a pas de dents ?',
        'propositions': ['Baleine', 'Serpent', 'Éléphant', 'Lapin'],
        'reponseIndex': 2,
      },
      {
        'question':
            'Lequel de ces villes n\'est pas situé en Amérique du Sud ?',
        'propositions': ['Buenos Aires', 'Rio de Janeiro', 'Caracas', 'Mexico'],
        'reponseIndex': 3,
      },
      {
        'question':
            'Lequel de ces langages de programmation n\'a pas été créé avant 2000 ?',
        'propositions': ['Python', 'Java', 'C++', 'Swift'],
        'reponseIndex': 3,
      },
      {
        'question':
            'Lequel de ces personnages de fiction n\'est pas un membre de la famille Simpson ?',
        'propositions': ['Homer', 'Marge', 'Lisa', 'Stan'],
        'reponseIndex': 3,
      },
      {
        'question':
            'Lequel de ces artistes n\'a pas été influencé par le mouvement surréaliste ?',
        'propositions': [
          'Salvador Dalí',
          'René Magritte',
          'Pablo Picasso',
          'Vincent van Gogh'
        ],
        'reponseIndex': 3,
      }
    ];
    _numQuestions = 6;
    _numCorrectAnswers = 0;
    _usedQuestions = {};
    _generateQuestion();
  }

  void _generateQuestion() {
    // Génère une nouvelle question aléatoire qui n'a pas encore été posée
    int randomIndex;
    do {
      randomIndex = Random().nextInt(_questions.length);
    } while (_usedQuestions.contains(randomIndex));
    _usedQuestions.add(randomIndex);

    if (_usedQuestions.length > _numQuestions) {
      // Si le nombre de questions utilisées atteint le nombre maximum de questions, affiche le résultat final
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Résultat final'),
            content: Text(
                'Vous avez obtenu $_numCorrectAnswers bonnes réponses sur $_numQuestions.'),
            actions: [
              TextButton(
                    child: const Text('OK'),
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                pseudo: nom_user,
                                nbVictoires: nb_victoires,
                                tempsTaupe: temps_taupe,
                                scoreAlien: scoreAlienRun,
                                tempsBoussole: temps_boussole,
                                tempsLab: temps_lab,)),
                      );
                    },
                  ),
            ],
          );
        },
      );
    } else {
      final question = _questions[randomIndex];
      final String q = question['question'];
      final List<String> props = List<String>.from(question['propositions']);
      final int ri = question['reponseIndex'];
      setState(() {
        _question = q;
        _propositions = props;
        _reponseIndex = ri;
      });
    }
  }

  void _checkAnswer(int index) {
    bool isCorrect = index == _reponseIndex;
    if (isCorrect) {
      _numCorrectAnswers++;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect ? "Correct!" : "Wrong answer",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isCorrect ? Colors.green : Colors.red,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        duration: Duration(seconds: 1),
        elevation: 10,
      ),
    );
    _generateQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lequel na pas... ?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _question,
              style: const TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 16.0),
            ..._propositions
                .asMap()
                .entries
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _checkAnswer(entry.key);
                      },
                      child: Text(entry.value),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
