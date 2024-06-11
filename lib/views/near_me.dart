import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_mushrooms_hunter/data/mushroom_provider.dart';
import 'package:my_mushrooms_hunter/models/mushroom.dart';

class NearMe extends StatefulWidget {
  final MushroomProvider mushroomProvider;
  NearMe({Key? key, required this.mushroomProvider}) : super(key: key);
  @override
  _NearMeState createState() => _NearMeState();
}

class _NearMeState extends State<NearMe> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  GoogleMapController? _mapController;
  LatLng _currentPosition = LatLng(0, 0);

  _NearMeState();

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    final Position position = await Geolocator.getCurrentPosition();
    final initialPosition = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentPosition = initialPosition;
    });

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: initialPosition,
          zoom: 20.0,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Widget buildMap(BuildContext context) {
    return StreamBuilder<List<Mushroom>>(
      stream: widget.mushroomProvider.mushroomsNearLocation(
        _currentPosition.latitude,
        _currentPosition.longitude,
        10, // radius in kilometers
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Text('Loading...');
          default:
            // Create a Set of markers from the list of mushrooms
            Set<Marker> markers = snapshot.data!
                .map((mushroom) => Marker(
                      markerId: MarkerId(mushroom.id!),
                      position: LatLng(
                        mushroom.geolocation.latitude,
                        mushroom.geolocation.longitude,
                      ),
                      infoWindow: InfoWindow(
                        title: mushroom.name,
                        snippet: mushroom.description,
                      ),
                    ))
                .toSet();

            // Add a marker for the current position
            markers.add(
              Marker(
                markerId: MarkerId('current_position'),
                position: _currentPosition,
                infoWindow: InfoWindow(
                  title: 'Current Position',
                ),
              ),
            );

            return GoogleMap(
              onMapCreated: _onMapCreated,
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 20,
              ),
              markers: markers,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Near Me"),
      ),
      body: buildMap(context),
    );
  }

  // @override
  // void dispose() {
  //   _mapController?.dispose();
  //   super.dispose();
  // }
}
