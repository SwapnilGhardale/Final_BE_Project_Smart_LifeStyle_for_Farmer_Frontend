import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_detector/data/plants.dart';
import 'package:plant_disease_detector/ui/result.dart';

class PlantDetails extends StatefulWidget {
  final Plant plant;

  const PlantDetails({Key? key, required this.plant}) : super(key: key);
  @override
  _PlantDetailsState createState() => _PlantDetailsState();
}

class _PlantDetailsState extends State<PlantDetails> {
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
              flexibleSpace: buildFlexibleSpaceBar(),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                diseaseList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  diseaseList() {
    List<Widget> list = [];
    for (int i = 0; i < 5; i++) {
      list.add(
        ExpansionTile(
          title: Text('Apple Scab'),
          children: [
            ListTile(
              title: Text('Causes'),
              subtitle: Text('It is caused by fungus Venturia inaequalis.'),
            ),
            ListTile(
              title: Text('Symptoms'),
              subtitle: Text(
                  'Twisted and puckered leaves that have black, circular scabby spots on the underside.'),
            ),
            ListTile(
              title: Text('Preventions'),
              subtitle: Text(
                  'Thoroughly remove fallen leaves, not only in the fall, but also during the growing season.'),
            ),
            ListTile(
              title: Text('Useful Pesticides'),
              subtitle: Text(
                  'Bonide Sulfur Plant Fungicide, Organocide Plant Doctor, Bonide Orchard Spray.'),
            ),
          ],
        ),
      );
    }
    return list;
  }

  FlexibleSpaceBar buildFlexibleSpaceBar() {
    return FlexibleSpaceBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            child: GestureDetector(
              onTap: () {
                getImage(ImageSource.gallery, widget.plant);
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.photo, color: Colors.white),
              ),
            ),
            decoration:
                BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          ),
          SizedBox(width: 16),
          Container(
            child: GestureDetector(
              onTap: () {
                getImage(ImageSource.camera, widget.plant);
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
            decoration:
                BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          ),
          SizedBox(width: 16),
        ],
      ),
      background: Hero(
        tag: widget.plant,
        child: Image.asset(
          widget.plant.plantImage,
          fit: BoxFit.cover,
        ),
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
