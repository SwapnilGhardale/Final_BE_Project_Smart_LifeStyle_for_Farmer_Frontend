import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_detector/data/plants.dart';
import 'package:plant_disease_detector/ui/mydrawer.dart';
import 'package:plant_disease_detector/ui/result.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _picker = ImagePicker();
  late Plant selectedPlant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Disease Detector'),
      ),
      drawer: MyDrawer(),
      body: ListView(
        children: [
          Divider(),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: demoPlants.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Image.asset(demoPlants[index]['image']),
                title: Text(demoPlants[index]['name']),
                onTap: () {
                  selectedPlant = Plant(
                    demoPlants[index]['id'],
                    demoPlants[index]['name'],
                    demoPlants[index]['image'],
                  );
                  plantTapped();
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  plantTapped() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Gallery'),
              onTap: () {
                getImage(ImageSource.gallery);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () {
                getImage(ImageSource.camera);
              },
            ),
            Divider(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  getImage(ImageSource imageSource) async {
    _picker
        .getImage(
      source: imageSource,
      maxHeight: 512,
      maxWidth: 512,
    )
        .then((res) {
      if (res != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Result(
              imagePath: res.path,
              currentPlant: selectedPlant,
            ),
          ),
        );
      }
    });
  }
}
