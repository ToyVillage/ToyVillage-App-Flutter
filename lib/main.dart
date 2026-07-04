import 'package:flutter/material.dart';

void main() {
  runApp(const ToyVillageApp());
}

class ToyVillageApp extends StatelessWidget {
  const ToyVillageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToyVillage',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToyVillage'),
      ),
      body: const Center(
        child: Text('ToyVillage'),
      ),
    );
  }
}
