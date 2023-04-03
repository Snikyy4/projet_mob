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
          tempsTaupe REAL
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


  Future<void> _saveUser(
      String username, String password, int nbVictoires, int tempsTaupe) async {
    final user = {
      'username': username,
      'password': password,
      'nbVictoires': nbVictoires,
      'tempsTaupe': tempsTaupe
    };
    await _database.insert('Users', user);
  }

  void _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      final user = await _getUserByUsername(username);
      if (user.isEmpty) {
  await _saveUser(username, password, 0, -1);

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
              navigateTo(context, MyHomePage(pseudo: username, nbVictoires: 0, tempsTaupe: -1,));
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
              navigateTo(context, MyHomePage(pseudo: username, nbVictoires: nbVictoires, tempsTaupe: tempsTaupe));
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
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/fond_ecran_bdd.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Nom d'utilisateur",
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Username';
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                ),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Mot de passe';
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _onSubmit,
                child: const Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
