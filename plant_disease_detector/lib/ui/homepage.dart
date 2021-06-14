import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_detector/data/plants.dart';
import 'package:plant_disease_detector/ui/mydrawer.dart';
import 'package:plant_disease_detector/ui/plantdetails.dart';
import 'package:plant_disease_detector/ui/result.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              return buildListTile(Plant.fromMap(plants[index]));
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

  ListTile buildListTile(Plant plant) {
    return ListTile(
      leading: Hero(
        tag: plant,
        child: ClipRRect(
          child: Image.asset(plant.plantImage),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      title: Text(plant.plantName),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => PlantDetails(plant: plant),
          ),
        );
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: GestureDetector(
              onTap: () {
                getImage(ImageSource.gallery, plant);
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.photo,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
            ),
          ),
          SizedBox(width: 16),
          Container(
            child: GestureDetector(
              onTap: () {
                getImage(ImageSource.camera, plant);
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
            ),
          ),
        ],
      ),
    );
  }

  getImage(ImageSource imageSource, Plant plant) async {
    ImagePicker()
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
              plant: plant,
            ),
          ),
        );
      }
    });
  }
}
