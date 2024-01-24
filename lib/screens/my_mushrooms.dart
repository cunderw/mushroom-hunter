import 'package:flutter/material.dart';

class MyMushrooms extends StatelessWidget {
  const MyMushrooms({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('My Mushrooms', style: Theme.of(context).textTheme.headline4),
        ],
      ),
    );
  }
}
