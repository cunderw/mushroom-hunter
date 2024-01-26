import 'package:flutter/material.dart';
import 'package:my_mushrooms_hunter/models/mushroom.dart';

class MushroomList extends StatefulWidget {
  final Stream<List<Mushroom>> streamMushrooms;
  const MushroomList({Key? key, required this.streamMushrooms})
      : super(key: key);
  @override
  _MushroomListState createState() => _MushroomListState();
}

class _MushroomListState extends State<MushroomList> {
  @override
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Mushroom>>(
      stream: widget.streamMushrooms,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Mushroom> mushrooms = snapshot.data!;
          return ListView.builder(
            itemCount: mushrooms.length,
            itemBuilder: (context, index) {
              Mushroom mushroom = mushrooms[index];
              return ListTile(
                title: Text(mushroom.name),
                subtitle: Text(mushroom.description),
              );
            },
          );
        } else {
          return Text('No mushrooms found');
        }
      },
    );
  }
}
