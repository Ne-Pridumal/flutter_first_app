import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:test_flutter/constants.dart';
import 'package:test_flutter/models/musicPlayer.dart';

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
          return Container(
            padding: const EdgeInsets.all(20),
            color: lightGrayColor,
            child: Container(
              color: Colors.white,
              child: SongsList(),
            ),
          );
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
    return ListView.builder(
      itemCount: MusicPlayer.songs.length,
      itemBuilder: (context, index) {
        SongModel song = MusicPlayer.songs[index];
        return Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            child: ListTile(
              textColor: textColor,
              title: Text(
                song.title,
              ),
              trailing: const Icon(Icons.more_vert),
              leading: QueryArtworkWidget(id: song.id, type: ArtworkType.AUDIO),
              onTap: () {},
            ));
      },
    );
  }
}
