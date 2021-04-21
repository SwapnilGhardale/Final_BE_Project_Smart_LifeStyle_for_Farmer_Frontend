import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Result extends StatefulWidget {
  final String imagePath;
  final String plant;
  final String imageLogo;
  final int plantIndex;

  const Result(
      {Key? key,
      required this.imagePath,
      required this.plant,
      required this.imageLogo,
      required this.plantIndex})
      : super(key: key);
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  bool loading = true;
  String serverResponse = '';

  getResult() async {
    var request =
        http.MultipartRequest('POST', Uri.parse('http://3.143.155.80/predict'));
    request.fields.addAll({'plant': widget.plantIndex.toString()});
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
                leading: Image.asset(widget.imageLogo),
                title: Text(widget.plant),
              ),
            ),
          ),
          Image.file(File(widget.imagePath), fit: BoxFit.contain),
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
        ],
      ),
    );
  }
}
