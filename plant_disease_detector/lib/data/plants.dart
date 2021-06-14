class Plant {
  final String plantId;
  final String plantName;
  final String plantImage;

  Plant(this.plantId, this.plantName, this.plantImage);

  Plant.fromMap(Map<String, String> map)
      : this.plantId = map['id']!,
        this.plantName = map['name']!,
        this.plantImage = map['image']!;
}

List plants = [
  {
    'id': 'ap',
    'name': 'Apple',
    'image': 'assets/apple.JPG',
  },
  {
    'id': 'bb',
    'name': 'Blueberry',
    'image': 'assets/blueberry.JPG',
  },
  {
    'id': 'ch',
    'name': 'Cherry',
    'image': 'assets/cherry.JPG',
  },
  {
    'id': 'co',
    'name': 'Corn',
    'image': 'assets/corn.jpg',
  },
  {
    'id': 'gr',
    'name': 'Grape',
    'image': 'assets/grape.JPG',
  },
  {
    'id': 'or',
    'name': 'Orange',
    'image': 'assets/orange.JPG',
  },
  {
    'id': 'ph',
    'name': 'Peach',
    'image': 'assets/peach.JPG',
  },
  {
    'id': 'pb',
    'name': 'Pepper Bell',
    'image': 'assets/pepperbell.JPG',
  },
  {
    'id': 'pt',
    'name': 'Potato',
    'image': 'assets/potato.JPG',
  },
  {
    'id': 'rb',
    'name': 'Raspberry',
    'image': 'assets/raspberry.JPG',
  },
  {
    'id': 'sy',
    'name': 'Soybean',
    'image': 'assets/soybean.JPG',
  },
  {
    'id': 'sq',
    'name': 'Squash',
    'image': 'assets/squash.JPG',
  },
  {
    'id': 'sb',
    'name': 'Strawberry',
    'image': 'assets/strawberry.JPG',
  },
  {
    'id': 'tm',
    'name': 'Tomato',
    'image': 'assets/tomato.JPG',
  },
];

List demoPlants = [
  {
    'id': 'tm',
    'name': 'Tomato',
    'image': 'assets/tomato.JPG',
  },
  {
    'id': 'pt',
    'name': 'Potato',
    'image': 'assets/potato.JPG',
  },
  {
    'id': 'gr',
    'name': 'Grape',
    'image': 'assets/grape.JPG',
  },
  {
    'id': 'co',
    'name': 'Corn',
    'image': 'assets/corn.jpg',
  },
  {
    'id': 'sb',
    'name': 'Strawberry',
    'image': 'assets/strawberry.JPG',
  },
];
