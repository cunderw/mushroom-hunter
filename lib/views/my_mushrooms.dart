import 'package:flutter/material.dart';
import 'package:my_mushrooms_hunter/widgets/mushroom_form.dart';
import 'package:my_mushrooms_hunter/widgets/mushroom_list.dart';

class MyMushrooms extends StatelessWidget {
  final mushroomProvider;
  MyMushrooms({Key? key, required this.mushroomProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('My Mushrooms'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => MushroomForm(
                          mushroomProvider: mushroomProvider,
                        )),
              );
            },
          ),
        ],
      ),
      body: MushroomList(
        mushroomProvider: mushroomProvider,
      ),
    );
  }
}
