import 'package:flutter/material.dart';
import 'package:projet_mob/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late Database _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'myapp.db');
    //await deleteDatabase(path); //si on veut remettre à jour la BDD
    _database = await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE Users (
          id INTEGER PRIMARY KEY,
          username TEXT UNIQUE,
          password TEXT,
          nbVictoires INTEGER,
          tempsTaupe REAL,
          scoreAlienRun INTEGER
        )
      ''');
    });
  }

  Future<Map<String, dynamic>> _getUserByUsername(String username) async {
    final db = await _database;
    final user = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    return user.isNotEmpty ? user.first : {};
  }

  Future<int> getVictoriesByUsername(String username) async {
    final db = await _database;
    final result = await db.rawQuery(
      'SELECT nbVictoires FROM Users WHERE username = ?',
      [username],
    );
    if (result.isNotEmpty) {
      return result.first['nbVictoires'] as int;
    } else {
      return 0;
    }
  }

  Future<double> getTempsTaupeByUsername(String username) async {
    final db = await _database;
    final result = await db.rawQuery(
      'SELECT tempsTaupe FROM Users WHERE username = ?',
      [username],
    );
    if (result.isNotEmpty) {
      return result.first['tempsTaupe'] as double;
    } else {
      return 0;
    }
  }

  Future<int> getScoreAlienRunByUsername(String username) async {
    final db = await _database;
    final result = await db.rawQuery(
      'SELECT scoreAlienRun FROM Users WHERE username = ?',
      [username],
    );
    if (result.isNotEmpty) {
      return result.first['scoreAlienRun'] as int;
    } else {
      return 0;
    }
  }

  Future<void> _saveUser(
      String username, String password, int nbVictoires, int tempsTaupe, int scoreAlienRun) async {
    final user = {
      'username': username,
      'password': password,
      'nbVictoires': nbVictoires,
      'tempsTaupe': tempsTaupe,
      'scoreAlienRun' : scoreAlienRun
    };
    await _database.insert('Users', user);
  }

  void _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      final user = await _getUserByUsername(username);
      if (user.isEmpty) {
        await _saveUser(username, password, 0, -1, -1);

        showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Inscription'),
              content: const Text('Inscription réussie'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    navigateTo(
                        context,
                        MyHomePage(
                          pseudo: username,
                          nbVictoires: 0,
                          tempsTaupe: -1,
                          scoreAlien: -1,
                        ));
                  },
                ),
              ],
            );
          },
        );
      } else if (user['password'] == password) {
        showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Connexion'),
              content: const Text('Connexion réussie'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final nbVictoires = await getVictoriesByUsername(username);
                    final tempsTaupe = await getTempsTaupeByUsername(username);
                    final scoreAlienRun = await getScoreAlienRunByUsername(username);
                    // ignore: use_build_context_synchronously
                    navigateTo(
                        context,
                        MyHomePage(
                            pseudo: username,
                            nbVictoires: nbVictoires,
                            tempsTaupe: tempsTaupe,
                            scoreAlien : scoreAlienRun));
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Connexion'),
              content:
                  const Text('Mot de passe incorrect ou username déjà utilisé'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/fond_ecran_bdd.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 150.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.white),
              ),
              child: const Text(
                "Bienvenue sur RocketLiche",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Text(
              "Veuillez vous connecter à votre compte",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontStyle: FontStyle.italic
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "Nom d'utilisateur",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Username';
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Mot de passe';
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                      ),
                      child: const Text('Se connecter'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
