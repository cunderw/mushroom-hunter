import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_mushrooms_hunter/data/mushroom_provider.dart';
import 'package:my_mushrooms_hunter/widgets/mushroom_form.dart';
import 'package:my_mushrooms_hunter/widgets/mushroom_list.dart';

class MyMushrooms extends StatelessWidget {
  MyMushrooms({super.key});
  final mushroomProvider = FirestoreMushroomProvider(
      firestore: FirebaseFirestore.instance,
      storage: FirebaseStorage.instance,
      userID: FirebaseAuth.instance.currentUser!.uid);

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
