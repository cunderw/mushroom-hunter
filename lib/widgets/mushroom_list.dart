import 'package:flutter/material.dart';
import 'package:my_mushrooms_hunter/models/mushroom.dart';
import 'package:my_mushrooms_hunter/services/firebase/mushroom_service.dart';
import 'package:my_mushrooms_hunter/widgets/mushroom_card.dart';

class MushroomList extends StatefulWidget {
  final Stream<List<Mushroom>> streamMushrooms;
  const MushroomList({Key? key, required this.streamMushrooms})
      : super(key: key);
  @override
  _MushroomListState createState() => _MushroomListState();
}

class _MushroomListState extends State<MushroomList> {
  Widget buildMushroomCard(Mushroom mushroom, int index) {
    return Dismissible(
      key: Key(mushroom.id!),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await deleteMushroom(mushroom.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mushroom deleted')),
        );
      },
      child: MushroomCard(mushroom: mushroom),
    );
  }

  Widget buildMushroomList(List<Mushroom> mushrooms) {
    return ListView.builder(
      itemCount: mushrooms.length,
      itemBuilder: (context, index) =>
          buildMushroomCard(mushrooms[index], index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Mushroom>>(
      stream: widget.streamMushrooms,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return buildMushroomList(snapshot.data!);
            } else {
              return Text('No mushrooms found');
            }
          default:
            return Text('Unexpected error');
        }
      },
    );
  }
}
