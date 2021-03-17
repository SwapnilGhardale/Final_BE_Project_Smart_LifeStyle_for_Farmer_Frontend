import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          ListTile(
            title: Text(
              'Plant',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ListTile(
            title: Text(
              'Disease',
              style: TextStyle(fontSize: 22),
            ),
          ),
          ListTile(
            title: Text(
              'Detector',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.translate_outlined),
            title: Text('Change Language'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
