import 'package:flutter/material.dart';
import 'package:my_mushrooms_hunter/models/mushroom.dart';
import 'package:my_mushrooms_hunter/data/mushroom_provider.dart';
import 'package:my_mushrooms_hunter/widgets/mushroom_card.dart';

class MushroomList extends StatelessWidget {
  final MushroomProvider mushroomProvider;
  MushroomList({Key? key, required this.mushroomProvider}) : super(key: key);

  Widget buildMushroomCard(BuildContext context, Mushroom mushroom, int index) {
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
        await mushroomProvider.deleteMushroom(mushroom.id!);
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
          buildMushroomCard(context, mushrooms[index], index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Mushroom>>(
      stream: mushroomProvider.userMushrooms(),
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
