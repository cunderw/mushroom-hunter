import 'package:flutter/material.dart';
import 'package:my_mushrooms_hunter/widgets/mushroom_form.dart';

class MyMushrooms extends StatelessWidget {
  const MyMushrooms({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: Row(
          children: <Widget>[
            Text('My Mushrooms'),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MushroomForm()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Item 1'),
          ),
          ListTile(
            title: Text('Item 2'),
          ),
        ],
      ),
    );
  }
}
