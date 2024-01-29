import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:my_mushrooms_hunter/models/mushroom.dart';

class MushroomCard extends StatelessWidget {
  final Mushroom mushroom;

  const MushroomCard({Key? key, required this.mushroom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      leading: CachedNetworkImage(
        imageUrl: mushroom.photoUrl,
        width: 75,
        height: 75,
        fit: BoxFit.cover,
        placeholder: (context, url) => PlatformCircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      title: PlatformText(mushroom.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PlatformText(mushroom.description),
          SizedBox(height: 4),
          PlatformText(DateFormat('yyyy-MM-dd').format(mushroom.dateFound)),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}
