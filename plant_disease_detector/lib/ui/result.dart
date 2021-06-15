import 'dart:io';
import 'dart:convert' as convert;

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
  double confidence = 0.0;
  var details;

  getResult() async {
    print('sending image to server');
    var request =
        http.MultipartRequest('POST', Uri.parse('http://3.143.155.80/predict'));
    request.fields.addAll({'plant_id': widget.plant.plantId});
    request.files
        .add(await http.MultipartFile.fromPath('file', widget.imagePath));
    print('sending request');

    await request.send().then((response) async {
      print(response.statusCode);
      if (response.statusCode == 200) {
        response.stream.bytesToString().then((body) {
          var jsonBody = convert.jsonDecode(body);
          if (jsonBody['status'] == 'OK') {
            confidence = double.parse(jsonBody['conf']);
            details = jsonBody['output'];
          } else {
            serverResponse = 'Leaf/Disease not detected.';
          }
        });
      } else {
        serverResponse = response.reasonPhrase!;
      }
    });

    print(serverResponse);
    setState(() {
      loading = false;
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
              delegate: SliverChildListDelegate(
                buildResult(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildResult() {
    List<Widget> widgetList = [];
    if (loading) {
      widgetList.add(ListTile(
        subtitle: LinearProgressIndicator(),
      ));
    } else {
      if (serverResponse.isNotEmpty) {
        widgetList.add(ListTile(
          title: Text(serverResponse),
        ));
      } else {
        if (details['disease_name'] == 'Healthy') {
          widgetList.add(ListTile(
            title: Text(details == null ? '' : 'This plant is healthy!'),
          ));
        } else {
          widgetList.add(ListTile(
            title: Text(details == null ? '' : details['disease_name']),
          ));
          widgetList.add(ListTile(
            title: Text('Causes'),
            subtitle: Text(details == null ? '' : details['causes']),
          ));
          widgetList.add(ListTile(
            title: Text('Symptoms'),
            subtitle: Text(details == null ? '' : details['symptoms']),
          ));
          widgetList.add(ListTile(
            title: Text('Preventions'),
            subtitle: Text(details == null ? '' : details['preventions']),
          ));
          widgetList.add(ListTile(
            title: Text('Useful Pesticides'),
            subtitle: Text(details == null ? '' : details['pesticides']),
          ));
        }
      }
    }
    return widgetList;
  }
}
