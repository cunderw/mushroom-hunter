import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_mushrooms_hunter/models/mushroom.dart';

class MushroomCard extends StatelessWidget {
  final Mushroom mushroom;

  MushroomCard({required this.mushroom}) : super();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: mushroom.photoUrl,
        width: 75,
        height: 75,
        fit: BoxFit.cover,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      title: Text(mushroom.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(mushroom.description),
          SizedBox(height: 4),
          Text(DateFormat('yyyy-MM-dd').format(mushroom.dateFound)),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}
