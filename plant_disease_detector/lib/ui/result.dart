import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  final image;
  final plant;
  final imageLogo;

  const Result({Key? key, this.image, this.plant, this.imageLogo})
      : super(key: key);
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
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
          Image.file(widget.image),
          Card(
            child: ListTile(
              title: Text('Disease Detected : Example'),
            ),
          ),
        ],
      ),
    );
  }
}
