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
  String selectedPlant = '';
  String selectedPlantLogo = '';
  String selectedImagePath = '';
  int selectedIndex = 1;

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
                  selectedPlant = demoPlants[index]['name'];
                  selectedPlantLogo = demoPlants[index]['image'];
                  selectedIndex = index + 1;
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
      maxHeight: 256,
      maxWidth: 256,
    )
        .then((res) {
      if (res != null) {
        setState(() {
          selectedImagePath = res.path;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Result(
              imagePath: selectedImagePath,
              plant: selectedPlant,
              imageLogo: selectedPlantLogo,
              plantIndex: selectedIndex,
            ),
          ),
        );
      }
    });
  }
}
