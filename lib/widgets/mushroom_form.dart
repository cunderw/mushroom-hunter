import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_mushrooms_hunter/widgets/image_picker.dart';
import 'package:my_mushrooms_hunter/widgets/location_picker.dart';
import 'package:image_picker/image_picker.dart';

class MushroomForm extends StatefulWidget {
  const MushroomForm({Key? key}) : super(key: key);
  @override
  _MushroomFormState createState() => _MushroomFormState();
}

class _MushroomFormState extends State<MushroomForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();

  XFile? _selectedImage;

  DateTime _dateAdded = DateTime.now();
  double? _latitude = null;
  double? _longitude = null;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateAdded, // Referencing the initial date
      firstDate: DateTime(2000), // Set this to your requirement
      lastDate: DateTime(2025), // Set this to your requirement
    );
    if (picked != null && picked != _dateAdded) {
      setState(() {
        _dateAdded = picked;
      });
    }
  }

  void _handleImageSelection(XFile? image) {
    setState(() {
      _selectedImage = image;
    });
    // You can further process the image, like uploading it to a server
  }

  Future<void> _selectLocation() async {
    final LatLng? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocationPicker(
          _latitude,
          _longitude,
        ),
      ),
    );

    setState(() {
      if (result == null) return;
      _latitude = result.latitude;
      _longitude = result.longitude;
    });
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the mushroom name';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description';
    }
    return null;
  }

  String _locationString() {
    if (_latitude == null || _longitude == null) return 'Select Location';
    return 'Lat: $_latitude, Lng: $_longitude';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Mushroom Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: _validateName,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: _validateDescription,
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  // Prevents the keyboard from showing
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText:
                          '${_dateAdded.toIso8601String().split('T').first}',
                      hintText: 'Date Found', // Display the selected date
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _selectLocation,
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true, // Makes the field non-editable
                    controller: TextEditingController(
                      text: _locationString(),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Location',
                      suffixIcon: Icon(Icons.map),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              CustomImagePicker(onImagePicked: _handleImageSelection),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process the data
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _nameController.dispose();
    _descriptionController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }
}
