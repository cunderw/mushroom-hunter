import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_mushrooms_hunter/widgets/location_picker.dart'; // For input formatters if needed

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
  DateTime _dateAdded =
      DateTime.now(); // Default to current date, can be changed

  // Dummy variables for geolocation, replace with actual implementation
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the mushroom name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: () => _selectDate(
                    context), // Call _selectDate when the field is tapped
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
              TextFormField(
                controller: _photoUrlController,
                decoration: InputDecoration(labelText: 'Photo URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the photo URL';
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: () async {
                  // Navigate to the LocationPicker and await the result
                  final LatLng? result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LocationPicker()),
                  );

                  // Update the state with the selected location
                  setState(() {
                    if (result == null) return;
                    _latitude = result.latitude;
                    _longitude = result.longitude;
                  });
                },
                child: AbsorbPointer(
                  // Prevents the keyboard from showing when tapping the field
                  child: TextFormField(
                    readOnly: true, // Makes the field non-editable
                    controller: TextEditingController(
                      text: _latitude != null && _longitude != null
                          ? 'Lat: $_latitude, Lng: $_longitude'
                          : 'Select Location',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Location',
                      suffixIcon: Icon(
                          Icons.map), // Optional: adds a map icon to the field
                    ),
                  ),
                ),
              ),
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
