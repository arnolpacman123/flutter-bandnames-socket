import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/src/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = 'home-page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = <Band>[
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 1),
    Band(id: '3', name: 'Héroes del Silencio', votes: 2),
    Band(id: '4', name: 'Bon Jovi', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Band Names', style: TextStyle(color: Colors.black87)),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (_, i) => _bandTile(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        elevation: 1.0,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id!),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('Direction: $direction');
        print('id: ${band.id!}');
        // TODO: llamar el borrado en el server
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle(color: Colors.white)),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name!.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name!),
        trailing:
            Text('${band.votes!}', style: const TextStyle(fontSize: 20.0)),
        onTap: () {
          print(band.name!);
        },
      ),
    );
  }

  void addNewBand() {
    final textController = TextEditingController();
    if (Platform.isAndroid) {
      // Android
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('New band name:'),
          content: TextField(controller: textController),
          actions: <Widget>[
            MaterialButton(
              child: const Text('Add'),
              elevation: 5.0,
              textColor: Colors.blue,
              onPressed: () => addBandToList(textController.text),
            ),
          ],
        ),
      );
      return;
    }
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('New ban name:'),
        content: CupertinoTextField(controller: textController),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Add'),
            onPressed: () => addBandToList(textController.text),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Dismiss'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void addBandToList(String name) {
    print(name);

    if (name.length > 1) {
      bands.add(Band(
        id: DateTime.now().toString(),
        name: name,
        votes: 0,
      ));
      setState(() {});
    }

    Navigator.pop(context);
  }
}
