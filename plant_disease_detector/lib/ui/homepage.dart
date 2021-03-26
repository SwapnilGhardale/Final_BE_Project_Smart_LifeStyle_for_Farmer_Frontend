import 'dart:io';
//import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
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
  late String imagePath;

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
                getGalleryImage();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () {
                getCameraImage();
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

  getGalleryImage() async {
    ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
    ).then((res) {
      if (res != null) {
        setState(() {
          imagePath = res[0].thumbPath!;
        });
        displayResult();
      }
    });
  }

  getCameraImage() {
    ImagesPicker.openCamera(
      pickType: PickType.image,
    ).then((res) {
      if (res != null) {
        setState(() {
          imagePath = res[0].thumbPath!;
        });
        displayResult();
      }
    });
  }

  displayResult() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => Result(
          image: File(imagePath),
          plant: selectedPlant,
          imageLogo: selectedPlantLogo,
        ),
      ),
    );
  }
}
