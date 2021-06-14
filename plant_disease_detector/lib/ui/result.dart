import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plant_disease_detector/data/plants.dart';

class Result extends StatefulWidget {
  final Plant plant;
  final String imagePath;

  const Result({Key? key, required this.plant, required this.imagePath})
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
    request.fields.addAll({'plant': widget.plant.plantId});
    request.files
        .add(await http.MultipartFile.fromPath('file', widget.imagePath));

    await request.send().then((response) async {
      print(response.statusCode);
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: size.width * 0.8,
              pinned: true,
              title: Text(
                widget.plant.plantName,
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                loading
                    ? ListTile(
                        subtitle: LinearProgressIndicator(),
                      )
                    : ListTile(
                        title: Text(serverResponse),
                      ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
