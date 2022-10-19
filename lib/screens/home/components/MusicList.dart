import 'package:MusicLibrary/constants.dart';
import 'package:MusicLibrary/models/musicPlayer.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicList extends StatefulWidget {
  const MusicList({super.key});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return FutureBuilder(
        future: MusicPlayer.audioQuery.querySongs(
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
          MusicPlayer.songs.clear();
          MusicPlayer.songs = item.data!;
          return Scrollbar(
              thickness: 8,
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                color: lightGrayColor,
                child: SongsList(),
              ));
        },
      );
    });
  }

  void requestStoragePermission() {
    MusicPlayer.checkMusicPermission();
    setState(() {});
  }
}

class SongsList extends StatelessWidget {
  const SongsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemBuilder: ((context, index) {
          final song = MusicPlayer.songs[index];
          return ListTile(
            textColor: textColor,
            title: Text(
              song.title,
            ),
            trailing: const Icon(Icons.more_vert),
            leading: QueryArtworkWidget(id: song.id, type: ArtworkType.AUDIO),
            onTap: () {
              MusicPlayer.setNewCurrentSongsList([song]);
              MusicPlayer.currentSongIndex = 0;
            },
          );
        }),
      ),
    );
  }
}
