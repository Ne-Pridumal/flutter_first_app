import 'package:MusicLibrary/constants.dart';
import 'package:MusicLibrary/models/musicPlayer.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SongMiniStatus extends StatefulWidget {
  const SongMiniStatus({super.key});

  @override
  State<SongMiniStatus> createState() => _SongMiniStatusState();
}

class _SongMiniStatusState extends State<SongMiniStatus> {
  final AudioPlayer _player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    MusicPlayer musicPlayer = Provider.of<MusicPlayer>(context);
    if (musicPlayer.isCurrentSongsEmpty()) {
      return Container(
        child: Text('no song'),
      );
    }

    return Consumer(
      builder: (context, value, child) {
        final currentId = musicPlayer.currentSongId;
        final SongModel song = musicPlayer.currentSongs[currentId];
        final AudioPlayer player = musicPlayer.player;
        return Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            child: ListTile(
              textColor: textColor,
              title: Text(song.title),
              leading: QueryArtworkWidget(id: song.id, type: ArtworkType.AUDIO),
              trailing: StreamBuilder<bool>(
                  stream: player.playingStream,
                  builder: ((context, snapshot) {
                    bool? playingState = snapshot.data;
                    if (playingState != null && playingState) {
                      return IconButton(
                        onPressed: () {
                          musicPlayer.stopMusic();
                        },
                        icon: const Icon(Icons.pause),
                        color: grayColor,
                        iconSize: 40,
                      );
                    }
                    return IconButton(
                      onPressed: () {
                        musicPlayer.playMusic();
                      },
                      icon: const Icon(Icons.play_arrow),
                      color: grayColor,
                      iconSize: 40,
                    );
                  })),
            ));
      },
    );
  }
}
