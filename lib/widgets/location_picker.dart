import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPicker extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  LocationPicker(this.initialLat, this.initialLng);
  @override
  _LocationPickerState createState() =>
      _LocationPickerState(initialLat, initialLng);
}

class _LocationPickerState extends State<LocationPicker> {
  GoogleMapController? _mapController;
  final double? initialLat;
  final double? initialLng;
  LatLng _currentPosition = LatLng(0, 0);
  LatLng? _selectedLocation;

  _LocationPickerState(this.initialLat, this.initialLng);
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _determineInitialPosition();
  }

  Future<void> _determineInitialPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    LatLng initialPosition;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    if (initialLat != null && initialLng != null) {
      initialPosition = LatLng(initialLat!, initialLng!);
    } else {
      Position position = await Geolocator.getCurrentPosition();
      initialPosition = LatLng(position.latitude, position.longitude);
    }

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

    if (_currentPosition.latitude != 0 && _currentPosition.longitude != 0) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentPosition,
            zoom: 20.0,
          ),
        ),
      );

      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('currentPos'),
            position: _currentPosition,
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      });
    }
  }

  void _handleSelectLocation(LatLng location) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('selectedPos'),
          position: location,
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      _selectedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Select Location"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, _selectedLocation);
            },
          ),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          mapType: MapType.hybrid,
          initialCameraPosition: CameraPosition(
            target: _currentPosition,
            zoom: 20.0,
          ),
          markers: _markers,
          onTap: _handleSelectLocation,
        ),
      ),
    );
  }
}
