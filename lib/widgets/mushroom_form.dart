import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();

  XFile? _selectedImage;

  DateTime _dateAdded = DateTime.now();
  double? _latitude = null;
  double? _longitude = null;
  bool _isLoading = false;

  void _showCupertinoDatePicker(BuildContext context) {
    showPlatformModalSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: CupertinoDatePicker(
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _dateAdded = newDate;
              });
            },
            maximumYear: DateTime.now().year,
            minimumYear: 2000,
            mode: CupertinoDatePickerMode
                .date, // Choose date, time or date and time mode according to your requirement
          ),
        );
      },
    );
  }

  Future<void> _showMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateAdded,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
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

  Future<bool> submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_latitude == null || _longitude == null) {
        await showPlatformDialog(
          context: context,
          builder: (context) {
            return PlatformAlertDialog(
              title: PlatformText('Error'),
              content: PlatformText('Please select a location'),
              actions: <Widget>[
                PlatformDialogAction(
                  child: PlatformText('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
        return false;
      }

      if (_selectedImage == null) {
        await showPlatformDialog(
          context: context,
          builder: (context) => PlatformAlertDialog(
            title: PlatformText('Error'),
            content: PlatformText('Please select an image'),
            actions: <Widget>[
              PlatformDialogAction(
                child: PlatformText('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
        return false;
      }

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
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText('Add Mushroom Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              PlatformTextFormField(
                controller: _nameController,
                material: (context, platform) => MaterialTextFormFieldData(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                cupertino: (context, platform) => CupertinoTextFormFieldData(
                  placeholder: 'Name',
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CupertinoColors.systemGrey,
                      width: 1,
                    ),
                  ),
                ),
                validator: _validateName,
              ),
              PlatformTextFormField(
                controller: _descriptionController,
                material: (context, platform) => MaterialTextFormFieldData(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                cupertino: (context, platform) => CupertinoTextFormFieldData(
                  placeholder: 'Description',
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CupertinoColors.systemGrey,
                      width: 1,
                    ),
                  ),
                ),
                validator: _validateDescription,
              ),
              GestureDetector(
                onTap: () => isIOS
                    ? _showCupertinoDatePicker(context)
                    : _showMaterialDatePicker(context),
                child: AbsorbPointer(
                  child: PlatformTextFormField(
                    controller: TextEditingController(
                      text: '${_dateAdded.toIso8601String().split('T').first}',
                    ),
                    material: (context, platform) => MaterialTextFormFieldData(
                      decoration: InputDecoration(
                        labelText:
                            '${_dateAdded.toIso8601String().split('T').first}',
                        hintText: 'Date Found',
                      ),
                    ),
                    cupertino: (context, platform) =>
                        CupertinoTextFormFieldData(
                      placeholder: 'Date Found',
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: CupertinoColors.systemGrey,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _selectLocation,
                child: AbsorbPointer(
                  child: PlatformTextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: _locationString(),
                    ),
                    material: (context, platform) => MaterialTextFormFieldData(
                      decoration: InputDecoration(
                        labelText: 'Location',
                        suffixIcon: Icon(Icons.map),
                      ),
                    ),
                    cupertino: (context, platform) =>
                        CupertinoTextFormFieldData(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: CupertinoColors.systemGrey,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              CustomImagePicker(onImagePicked: _handleImageSelection),
              SizedBox(height: 16.0),
              PlatformElevatedButton(
                onPressed: () async {
                  if (_isLoading) return;
                  bool isSubmitted = await submitForm();
                  if (isSubmitted) {
                    Navigator.of(context).pop();
                  }
                },
                child: _isLoading
                    ? PlatformCircularProgressIndicator(
                        material: (context, platform) =>
                            MaterialProgressIndicatorData(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : PlatformText('Submit'),
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
