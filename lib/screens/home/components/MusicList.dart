import 'package:MusicLibrary/constants.dart';
import 'package:MusicLibrary/models/musicPlayer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MusicList extends StatefulWidget {
  const MusicList({super.key});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    MusicPlayer musicPlayer = Provider.of<MusicPlayer>(context);
    return Builder(builder: (context) {
      return Consumer<MusicPlayer>(
          builder: (BuildContext context, MusicPlayer value, child) {
        return FutureBuilder(
          future: _audioQuery.querySongs(
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (context, item) {
            if (item.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (item.data!.isEmpty) {
              return const Center(
                child: Text("No Songs Found"),
              );
            }
            if (item.data != musicPlayer.songs) {
              musicPlayer.songsList = item.data!;
            }
            return Scrollbar(
                thickness: 6,
                isAlwaysShown: true,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  color: lightGrayColor,
                  child: Column(children: [
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        textColor: orangeColor,
                        leading: IconButton(
                          onPressed: () {
                            musicPlayer.shuffleAll();
                          },
                          icon: const Icon(Icons.shuffle, size: 30),
                          color: orangeColor,
                        ),
                        title: Text('Shuffle  all'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Readex Pro',
                            )),
                      ),
                    ),
                    SongsList(),
                  ]),
                ));
          },
        );
      });
    });
  }

  void requestStoragePermission() async {
    if (!kIsWeb) {
      bool permissionaStatus = await _audioQuery.permissionsStatus();
      if (!permissionaStatus) {
        await _audioQuery.permissionsRequest();
      }
    }

    setState(() {});
  }
}

class SongsList extends StatelessWidget {
  const SongsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MusicPlayer musicPlayer = Provider.of<MusicPlayer>(context);
    return Consumer(
      builder: ((context, value, child) {
        return Expanded(
            child: Container(
                color: Colors.white,
                child: ListView.builder(
                  physics: const ScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: musicPlayer.songs.length,
                  itemBuilder: ((context, index) {
                    final song = musicPlayer.songs[index];
                    return ListTile(
                      textColor: textColor,
                      title: Text(
                        song.title,
                      ),
                      trailing: const Icon(Icons.more_vert),
                      leading: QueryArtworkWidget(
                          id: song.id, type: ArtworkType.AUDIO),
                      onTap: () async {
                        musicPlayer.currentSongsList = [song];
                        musicPlayer.currentSongIndex = 0;
                        musicPlayer.setMusic();
                      },
                    );
                  }),
                )));
      }),
    );
  }
}
