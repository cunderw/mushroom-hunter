import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_mushrooms_hunter/models/mushroom.dart';
import 'package:my_mushrooms_hunter/services/firebase/mushroom_service.dart';
import 'package:my_mushrooms_hunter/services/firebase/storage_service.dart';

Future<void> submitMushroom(XFile image, String name, String description,
    LatLng geolocation, DateTime dateFound) async {
  String photoUrl = await uploadImage(image);
  Mushroom mushroom = Mushroom(
    name: name,
    description: description,
    geolocation: geolocation,
    photoUrl: photoUrl,
    dateFound: dateFound,
  );
  await saveMushroom(mushroom);
}
