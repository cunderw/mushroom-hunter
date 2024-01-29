import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:my_mushrooms_hunter/services/firebase/mushroom_service.dart';
import 'package:my_mushrooms_hunter/widgets/mushroom_form.dart';
import 'package:my_mushrooms_hunter/widgets/mushroom_list.dart';

class MyMushrooms extends StatelessWidget {
  MyMushrooms({super.key});
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: new Text('My Mushrooms'),
        trailingActions: <Widget>[
          PlatformIconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MushroomForm()),
              );
            },
          ),
        ],
      ),
      body: MushroomList(
        streamMushrooms: streamUserMushrooms(currentUserId),
      ),
    );
  }
}
