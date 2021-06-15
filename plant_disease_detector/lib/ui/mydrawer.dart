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
          Container(
            height: 200,
            padding: EdgeInsets.only(left: 20, top: 20),
            color: Theme.of(context).backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plant',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Disease',
                  style: TextStyle(fontSize: 23),
                ),
                Text(
                  'Detector',
                  style: TextStyle(fontSize: 28),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            subtitle: Text('Steps'),
          ),
          ListTile(
            leading: Icon(Icons.touch_app_outlined),
            title: Text('Select plant'),
          ),
          ListTile(
            leading: Icon(Icons.wallpaper),
            title: Text('Pick image'),
          ),
          ListTile(
            leading: Icon(Icons.subject),
            title: Text('Get result'),
          ),
        ],
      ),
    );
  }
}
