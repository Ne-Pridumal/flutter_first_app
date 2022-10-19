import 'package:MusicLibrary/constants.dart';
import 'package:MusicLibrary/screens/home/components/MusicList.dart';
import 'package:MusicLibrary/screens/home/components/SongMiniStatus.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Library'),
        backgroundColor: orangeColor,
        elevation: 0,
      ),
      body: const MusicList(),
      bottomNavigationBar: SongMiniStatus(),
    );
  }
}
