import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plant_disease_detector/data/plants.dart';

class Result extends StatefulWidget {
  final Plant currentPlant;
  final String imagePath;

  const Result({
    Key? key,
    required this.currentPlant,
    required this.imagePath,
  }) : super(key: key);
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  bool loading = true;
  String serverResponse = '';

  getResult() async {
    var request =
        http.MultipartRequest('POST', Uri.parse('http://3.143.155.80/predict'));
    request.fields.addAll({'plant': widget.currentPlant.plantId});
    request.files
        .add(await http.MultipartFile.fromPath('file', widget.imagePath));

    await request.send().then((response) async {
      if (response.statusCode == 200) {
        response.stream.bytesToString().then((value) {
          setState(() {
            serverResponse = value;
          });
        });
      } else {
        setState(() {
          serverResponse = response.reasonPhrase!;
        });
      }
      setState(() {
        loading = false;
        print(serverResponse);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Image.asset(widget.currentPlant.plantImage),
                title: Text(widget.currentPlant.plantName),
              ),
            ),
          ),
          Card(
            child: loading
                ? ListTile(
                    title: Text('Detecting Disease...'),
                    subtitle: LinearProgressIndicator(),
                  )
                : ListTile(
                    title: Text('Disease Detected : ' + serverResponse),
                  ),
          ),
          Image.file(File(widget.imagePath), fit: BoxFit.fitWidth),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
