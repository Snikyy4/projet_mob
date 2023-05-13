import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:projet_mob/taupes.dart';
import 'dart:async';
import 'main.dart';
import 'taupes.dart';

import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';

final _flutterP2pConnectionPlugin = FlutterP2pConnection();

double taupe1 = 0;
double taupe2 = 0;
int alienRun1 = 0;
int alienRun2 = 0;
double boussole1 = 0;
double boussole2 = 0;

bool finJ1 = false;
bool finJ2 = false;

String nomJ1 = '';
String nomJ2 = '';

class ModeMulti extends StatelessWidget {
  const ModeMulti({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MultiPage(),
    );
  }
}

class MultiPage extends StatefulWidget {
  const MultiPage({super.key});

  @override
  State<MultiPage> createState() => _MultiPageState();
}

class _MultiPageState extends State<MultiPage> with WidgetsBindingObserver {
  List<DiscoveredPeers> _peers = [];
  WifiP2PInfo? wifiP2PInfo;
  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;
  bool _discovering = false;
  String deviceConnected = '';

  @override
  void initState() {
    super.initState();
    _startDiscovery();
    _init();
  }

  @override
  void dispose() {
    _stopDiscovery();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _flutterP2pConnectionPlugin.unregister();
    } else if (state == AppLifecycleState.resumed) {
      _flutterP2pConnectionPlugin.register();
    }
  }

  void _init() async {
    finJ1 = false;
    finJ2 = false;
    await _flutterP2pConnectionPlugin.initialize();
    await _flutterP2pConnectionPlugin.register();
    _streamWifiInfo =
        _flutterP2pConnectionPlugin.streamWifiP2PInfo().listen((event) {
      setState(() {
        wifiP2PInfo = event;
      });
    });
    _streamPeers = _flutterP2pConnectionPlugin.streamPeers().listen((event) {
      setState(() {
        _peers = event;
        print(_peers);
      });
    });
  }

  void _startDiscovery() async {
    await _flutterP2pConnectionPlugin.discover();
    setState(() {
      _discovering = true;
    });
  }

  void _stopDiscovery() async {
    await _flutterP2pConnectionPlugin.stopDiscovery();
    setState(() {
      _discovering = false;
    });
  }

  void _connectToDevice(DiscoveredPeers device) async {
    try {
      await _flutterP2pConnectionPlugin.connect(device.deviceAddress);
      // Création de la socket
      deviceConnected = device.deviceName;
    } catch (e) {
      print(e);
    }
  }

  Future startSocket() async { //Joueur 1
    if (wifiP2PInfo != null) {
      bool started = await _flutterP2pConnectionPlugin.startSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 2,
        deleteOnError: true,
        onConnect: (name, address) {
          nomJ1 = nom_user;
          navigateTo(
              context, const MoleGame(isMultiplayer: true, isPlayerOne: true));
          snack("$name connected to socket with address: $address");
        },
        transferUpdate: (transfer) {
          if (transfer.completed) {
            snack(
                "${transfer.failed ? "failed to ${transfer.receiving ? "receive" : "send"}" : transfer.receiving ? "received" : "sent"}: ${transfer.filename}");
          }
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        receiveString: (req) async {
          print('joueur1 recoit du joueur2');
          if (req.contains('T2')) {
            print('a $req');
            List<String> tmp = req.split('/');
            taupe2 = double.parse(tmp[1]);
            //snack('joueur 2 envoie valeur taupe $taupe2');
            print("$finJ1 kaka $finJ2");
          }
          if (req.contains('AR2')) {
             print('b $req');
            alienRun2 = int.parse(req.split('/')[1]);
            finJ2 = true;
            print("$finJ1 lol $finJ2");
            //snack('joueur 2 envoie valeur alien $alienRun2');
          }
        },
      );
      snack("open socket: $started");
      // ignore: use_build_context_synchronously
    }
  }

  Future connectToSocket() async { // Joueur 2
    if (wifiP2PInfo != null) {
      await _flutterP2pConnectionPlugin.connectToSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 3,
        deleteOnError: true,
        onConnect: (address) {
          nomJ2 = nom_user;
          navigateTo(
              context,
              const MoleGame(
                isMultiplayer: true,
                isPlayerOne: false,
              ));
        },
        transferUpdate: (transfer) {
          if (transfer.completed) {
            snack(
                "${transfer.failed ? "failed to ${transfer.receiving ? "receive" : "send"}" : transfer.receiving ? "received" : "sent"}: ${transfer.filename}");
          }
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        receiveString: (req) async {
          if (req.contains('T1')) {
            print('c $req');
            List<String> tmp = req.split('/');
            taupe1 = double.parse(tmp[1]);
            //snack('joueur 1 envoie valeur taupe $taupe1');
            print("$finJ1 pour $finJ2");
          }
          if (req.contains('AR1')) {
            print('d $req');
            alienRun1 = int.parse(req.split('/')[1]);
            finJ1 = true;
            //snack('joueur 1 envoie valeur alien $alienRun1');
            print("$finJ1 avec $finJ2");
          }
        },
      );
    }
  }

  Future closeSocketConnection() async {
    bool closed = _flutterP2pConnectionPlugin.closeSocket();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "closed: $closed",
        ),
      ),
    );
  }

  void snack(String msg) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          msg,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discovery'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_discovering) const CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _peers.length,
              itemBuilder: (BuildContext context, int index) {
                final device = _peers[index];
                return ListTile(
                  title: Text(device.deviceName),
                  subtitle: Text(device.deviceAddress),
                  onTap: () => _connectToDevice(device),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _flutterP2pConnectionPlugin.removeGroup();
              snack("Déco");
            },
            child: const Text("Se déco"),
          ),
          ElevatedButton(
            onPressed: () async {
              startSocket();
            },
            child: const Text("open a socket"),
          ),
          ElevatedButton(
            onPressed: () async {
              connectToSocket();
            },
            child: const Text("connect to socket"),
          ),
          ElevatedButton(
            onPressed: () async {
              closeSocketConnection();
            },
            child: const Text("close socket"),
          ),
          Text('Connected to: $deviceConnected'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(_discovering ? Icons.stop : Icons.search),
        onPressed: _discovering ? _stopDiscovery : _startDiscovery,
      ),
    );
  }
}

Future sendMessage(msg) async {
  _flutterP2pConnectionPlugin.sendStringToSocket(msg);
}
