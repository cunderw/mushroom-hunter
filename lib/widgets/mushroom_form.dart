import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_mushrooms_hunter/controllers/mushroom_controller.dart';
import 'package:my_mushrooms_hunter/widgets/image_picker.dart';
import 'package:my_mushrooms_hunter/widgets/location_picker.dart';
import 'package:image_picker/image_picker.dart';

bool isIOS = Platform.isIOS;

class MushroomForm extends StatefulWidget {
  const MushroomForm({Key? key}) : super(key: key);
  @override
  _MushroomFormState createState() => _MushroomFormState();
}

class _MushroomFormState extends State<MushroomForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();

  XFile? _selectedImage;

  DateTime _dateAdded = DateTime.now();
  double? _latitude = null;
  double? _longitude = null;
  bool _isLoading = false;

  String _locationString() {
    if (_latitude == null || _longitude == null) return 'Select Location';
    return 'Lat: $_latitude, Lng: $_longitude';
  }

  // Selectors
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateAdded,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _dateAdded) {
      setState(() {
        _dateAdded = picked;
        _dateController.text =
            '${_dateAdded.toIso8601String().split('T').first}';
      });
    }
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
      _locationController.text = _locationString();
    });
  }

  void selectImage(XFile? image) {
    setState(() {
      _selectedImage = image;
    });
  }

  // Validators
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the mushroom name.';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description.';
    }
    return null;
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date.';
    }
    return null;
  }

  String? _validateLocation(String? value) {
    if (value == null ||
        value.isEmpty ||
        _latitude == null ||
        _longitude == null) {
      return 'Please select a location.';
    }
    return null;
  }

  String? _validateImage(dynamic value) {
    if (_selectedImage == null) {
      return 'Please select an image';
    }
    return null;
  }

  Future<bool> submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await submitMushroom(
        _selectedImage!,
        _nameController.text,
        _descriptionController.text,
        LatLng(
          _latitude!,
          _longitude!,
        ),
        _dateAdded,
      );

      setState(() {
        _isLoading = false;
      });

      return true;
    }
    return false;
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
                  decoration: const InputDecoration(labelText: "Name"),
                  controller: _nameController,
                  validator: _validateName,
                  onChanged: (value) {
                    _formKey.currentState!.validate();
                  }),
              TextFormField(
                  decoration: const InputDecoration(labelText: "Description"),
                  controller: _descriptionController,
                  validator: _validateDescription,
                  onChanged: (value) {
                    _formKey.currentState!.validate();
                  }),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Date Found"),
                      controller: _dateController,
                      validator: _validateDate,
                      onChanged: (value) {
                        _formKey.currentState!.validate();
                      }),
                ),
              ),
              GestureDetector(
                onTap: _selectLocation,
                child: AbsorbPointer(
                  child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Location Found"),
                      readOnly: true,
                      controller: _locationController,
                      validator: _validateLocation,
                      onChanged: (value) {
                        _formKey.currentState!.validate();
                      }),
                ),
              ),
              SizedBox(height: 16.0),
              FormField(
                validator: _validateImage,
                builder: (FormFieldState state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomImagePicker(onImagePicked: selectImage),
                      state.hasError ? SizedBox(height: 5.0) : Container(),
                      state.hasError
                          ? Text(
                              state.errorText!,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            )
                          : Container(),
                    ],
                  );
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_isLoading) return;
                  bool isSubmitted = await submitForm();
                  if (isSubmitted) {
                    Navigator.of(context).pop();
                  }
                },
                child:
                    _isLoading ? CircularProgressIndicator() : Text('Submit'),
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
    _dateController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
