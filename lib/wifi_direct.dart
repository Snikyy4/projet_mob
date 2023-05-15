import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:projet_mob/taupes.dart';
import 'dart:async';
import 'main.dart';
import 'taupes.dart';
import 'package:audioplayers/audioplayers.dart';


import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';

final _flutterP2pConnectionPlugin = FlutterP2pConnection();

double taupe1 = 0;
double taupe2 = 0;
int alienRun1 = 0;
int alienRun2 = 0;

bool finJ1 = false;
bool finJ2 = false;

int nbVicJ1 = 0;
int nbVicJ2 = 0;

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

AudioPlayer audioPlayer = AudioPlayer();
  String url = 'https://www.youtube.com/watch?v=XE6YaLtctcI';



  @override
  void initState() {
    super.initState();
    audioPlayer.setUrl(url);
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
          if (req.contains('T2')) {
            List<String> tmp = req.split('/');
            taupe2 = double.parse(tmp[1]);
          }
          if (req.contains('AR2')) {
            alienRun2 = int.parse(req.split('/')[1]);
            finJ2 = true;
          }
          if(req.contains('NV2')){ //nb victoires
            nbVicJ2 = int.parse(req.split('/')[1]);
            print("$req et $nbVicJ2");
          }
          if(req.contains('P2')){ //nom player
          List<String> tmp = req.split('/');
          nomJ2 = tmp[1];
          }
          if(req.contains('WIN')){
            //Jouer défaite
            audioPlayer.play(url);
          }
        },
      );
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
          if (req.contains('T1')) { //temps taupe
            List<String> tmp = req.split('/');
            taupe1 = double.parse(tmp[1]);
          }
          if (req.contains('AR1')) { // score alien run
            alienRun1 = int.parse(req.split('/')[1]);
            finJ1 = true;
          }
          if(req.contains('NV1')){ //nb victoires
            nbVicJ1 = int.parse(req.split('/')[1]);
          }
          if(req.contains('P1')){ //nom player
          List<String> tmp = req.split('/');
          nomJ1 = tmp[1];
          }
          if(req.contains('WIN')){
            //Jouer défaite
            audioPlayer.play(url);
          }
        },
      );
    }
  }

  Future closeSocketConnection() async {
    _flutterP2pConnectionPlugin.closeSocket();
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
        title: const Text('Recherche de joueurs en ligne'),
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
            },
            child: const Text("Se déconnecter"),
          ),
          ElevatedButton(
            onPressed: () async {
              startSocket();
            },
            child: const Text("Ouverture du groupe"),
          ),
          ElevatedButton(
            onPressed: () async {
              connectToSocket();
            },
            child: const Text("Rejoindre le groupe"),
          ),
          ElevatedButton(
            onPressed: () async {
              closeSocketConnection();
            },
            child: const Text("Quitter le groupe"),
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
