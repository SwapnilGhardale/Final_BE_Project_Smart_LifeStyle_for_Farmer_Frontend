import 'dart:io';
import 'package:flutter/services.dart';
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
  String selectedPlant = '';
  String selectedPlantLogo = '';
  File _image;
  final picker = ImagePicker();

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
            itemCount: plants.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Image.asset(plants[index]['image']),
                title: Text(plants[index]['name']),
                onTap: () {
                  selectedPlant = plants[index]['name'];
                  selectedPlantLogo = plants[index]['image'];
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

  Future getImage(_source) async {
    picker.getImage(source: _source).then((pickedFile) {
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => Result(
            image: _image,
            plant: selectedPlant,
            imageLogo: selectedPlantLogo,
          ),
        ),
      );
    });
  }
}
