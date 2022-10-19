import 'package:MusicLibrary/constants.dart';
import 'package:MusicLibrary/models/musicPlayer.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongMiniStatus extends StatefulWidget {
  const SongMiniStatus({super.key});

  @override
  State<SongMiniStatus> createState() => _SongMiniStatusState();
}

class _SongMiniStatusState extends State<SongMiniStatus> {
  @override
  Widget build(BuildContext context) {
    if (MusicPlayer.currentSongsList.isEmpty) {
      return Container(
        child: Text('no song'),
      );
    }
    final SongModel song =
        MusicPlayer.currentSongsList[MusicPlayer.currentSongIndex];

    return Container(
        height: 100,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        child: ListTile(
          textColor: textColor,
          title: Text(song.title),
          leading: QueryArtworkWidget(id: song.id, type: ArtworkType.AUDIO),
        ));
  }
}
