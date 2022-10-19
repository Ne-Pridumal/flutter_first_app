import 'package:MusicLibrary/models/musicPlayer.dart';
import 'package:MusicLibrary/screens/home/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MusicPlayer(),
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
