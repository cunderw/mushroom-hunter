import 'package:flutter/material.dart';

class NearMe extends StatelessWidget {
  const NearMe({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Near Me', style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}
