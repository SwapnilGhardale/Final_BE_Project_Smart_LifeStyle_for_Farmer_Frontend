import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
  bool loading = true;
  String serverResponse = '';
  List<dynamic> infoList = [];

  getInfo() async {
    var request =
        MultipartRequest('POST', Uri.parse('http://3.143.155.80/plant_info'));
    request.fields.addAll({'plant_id': widget.plant.plantId});

    StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = await response.stream.bytesToString();
      var jsonBody = convert.jsonDecode(body);
      infoList = jsonBody['info'];
    } else {
      serverResponse = response.reasonPhrase!;
    }
    setState(() {
      loading = false;
      print(serverResponse);
    });
  }

  @override
  void initState() {
    super.initState();
    getInfo();
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
              flexibleSpace: buildFlexibleSpaceBar(),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                buildInfoList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildInfoList() {
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
        infoList.forEach((element) {
          widgetList.add(
            ExpansionTile(
              title: Text(element['disease_name'] ?? ''),
              children: [
                ListTile(
                  title: Text('Causes'),
                  subtitle: Text(element['causes'] ?? ''),
                ),
                ListTile(
                  title: Text('Symptoms'),
                  subtitle: Text(element['symptoms'] ?? ''),
                ),
                ListTile(
                  title: Text('Preventions'),
                  subtitle: Text(element['preventions'] ?? ''),
                ),
                ListTile(
                  title: Text('Useful Pesticides'),
                  subtitle: Text(element['pesticides'] ?? ''),
                ),
              ],
            ),
          );
        });
      }
    }
    return widgetList;
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
