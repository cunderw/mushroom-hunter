import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_mushrooms_hunter/models/mushroom.dart';

class MushroomCard extends StatelessWidget {
  final Mushroom mushroom;

  const MushroomCard({Key? key, required this.mushroom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          mushroom.photoUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(mushroom.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(mushroom.description),
            SizedBox(height: 4),
            Text(DateFormat('yyyy-MM-dd').format(mushroom.dateFound)),
          ],
        ),
      ),
    );
  }
}
