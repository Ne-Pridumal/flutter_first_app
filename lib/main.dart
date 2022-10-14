import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterPlay Songs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'FlutterPlay Songs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // bg color
  Color bgColor = Colors.white;

  //define on audio plugin
  final OnAudioQuery _audioQuery = OnAudioQuery();

  //player
  final AudioPlayer _player = AudioPlayer();

  //variables
  List<SongModel> songs = [];
  String currentSongTitle = '';
  int currentIndex = 0;

  bool isPlayerViewVisible = false;

  void _changePlayerVisibility() {
    setState(() {
      isPlayerViewVisible = !isPlayerViewVisible;
    });
  }

  //duration state stream
  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          _player.positionStream,
          _player.durationStream,
          (postion, duration) => DurationState(
              position: postion, total: duration ?? Duration.zero));

  //request permission from initStateMethod
  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    //update the current player song index
    _player.currentIndexStream.listen((index) {
      if (index != null) {
        _updateCurrentPLayingSongDetails(index);
      }
    });
  }

  //dispose player
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isPlayerViewVisible) {
      return Scaffold(
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 56, right: 20, left: 20),
            decoration: BoxDecoration(color: bgColor),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          _changePlayerVisibility();
                          _player.stop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: getDecoration(
                              BoxShape.circle, const Offset(2, 2), 2, 0),
                          child: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.blue),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(currentSongTitle,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                      flex: 5,
                    ),
                  ],
                ),
                //artwork
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: 300,
                  height: 300,
                  decoration:
                      getDecoration(BoxShape.circle, const Offset(2, 2), 2, 2),
                  child: QueryArtworkWidget(
                    id: songs[currentIndex].id,
                    type: ArtworkType.AUDIO,
                    artworkBorder: BorderRadius.circular(200),
                  ),
                ),

                //slider, position and duration
                Column(children: [
                  //slider bar container
                  Container(
                    margin: const EdgeInsets.only(top: 40, bottom: 4),
                    child: StreamBuilder<DurationState>(
                      stream: _durationStateStream,
                      builder: (context, snapshot) {
                        final durationState = snapshot.data;
                        final progress =
                            durationState?.position ?? Duration.zero;
                        final total = durationState?.total ?? Duration.zero;

                        return ProgressBar(
                          thumbCanPaintOutsideBar: true,
                          progress: progress,
                          total: total,
                          barHeight: 2,
                          baseBarColor: bgColor,
                          progressBarColor: Colors.blue,
                          thumbColor: Colors.black54.withBlue(99),
                          timeLabelTextStyle: const TextStyle(
                            fontSize: 0,
                          ),
                          onSeek: (duration) => _player.seek(duration),
                        );
                      },
                    ),
                  ),
                  //position/progress and total text
                  StreamBuilder<DurationState>(
                    stream: _durationStateStream,
                    builder: ((context, snapshot) {
                      final durationState = snapshot.data;
                      final progress = durationState?.position ?? Duration.zero;
                      final total = durationState?.total ?? Duration.zero;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: Text(progress.toString().split('.')[0],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                )),
                          ),
                          Flexible(
                            child: Text(total.toString().split('.')[0],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                )),
                          ),
                        ],
                      );
                    }),
                  )
                ]),
                //prev, play/pause & seek next control buttons
                Container(
                    margin: const EdgeInsets.only(top: 50, bottom: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              if (_player.hasPrevious) {
                                _player.seekToPrevious();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: getDecoration(
                                  BoxShape.circle, const Offset(2, 2), 2, 2),
                              child: const Icon(Icons.skip_previous,
                                  color: Colors.blue),
                            ), //Container
                          ), //InkWell
                        ), //Flexible

                        Flexible(
                          child: InkWell(
                            onTap: () {
                              if (_player.playing) {
                                _player.pause();
                              } else {
                                if (_player.currentIndex != null) {
                                  _player.play();
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              decoration: getDecoration(
                                  BoxShape.circle, const Offset(2, 2), 2, 2),
                              child: StreamBuilder<bool>(
                                  stream: _player.playingStream,
                                  builder: (context, snapshot) {
                                    bool? playingState = snapshot.data;
                                    if (playingState != null && playingState) {
                                      return const Icon(Icons.pause,
                                          size: 40, color: Colors.blue);
                                    }
                                    return const Icon(Icons.play_arrow,
                                        size: 40, color: Colors.blue);
                                  }), //StreamBuilder
                            ), //Container
                          ), //InkWell
                        ), //Flexible
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              if (_player.hasNext) {
                                _player.seekToNext();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: getDecoration(
                                  BoxShape.circle, const Offset(2, 2), 2, 2),
                              child: const Icon(Icons.skip_next,
                                  color: Colors.blue),
                            ), //Container
                          ), //InkWell
                        ), //Flexible
                      ],
                    ) //Row
                    ), //Container

                // go to playlist, shuffle, repeate all and repeate current
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: () => _changePlayerVisibility(),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: getDecoration(
                                BoxShape.circle, const Offset(2, 2), 2, 2),
                            child:
                                const Icon(Icons.list_alt, color: Colors.blue),
                          ), //Container
                        ), //InkWell
                      ), //Flexible
                      //Shuffle
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            _player.setShuffleModeEnabled(true);
                            toast(context, 'Shuffling enable');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            decoration: getDecoration(
                                BoxShape.circle, const Offset(2, 2), 2, 2),
                            child:
                                const Icon(Icons.shuffle, color: Colors.blue),
                          ), //Container
                        ), //InkWell
                      ), //Flexible
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            _player.loopMode == LoopMode.one
                                ? _player.setLoopMode(LoopMode.all)
                                : _player.setLoopMode(LoopMode.one);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: getDecoration(
                                BoxShape.circle, const Offset(2, 2), 2, 2),
                            child: StreamBuilder<LoopMode>(
                              stream: _player.loopModeStream,
                              builder: ((context, snapshot) {
                                final loopMode = snapshot.data;
                                if (LoopMode.one == loopMode) {
                                  return const Icon(Icons.repeat_one,
                                      color: Colors.blue);
                                }
                                return const Icon(Icons.repeat,
                                    color: Colors.blue);
                              }),
                            ), //StreamBuilder
                          ), //Container
                        ), //InkWell
                      ), //Flexible
                    ],
                  ), //Row
                ), //Container
              ], //<Widget>[]
            ), //Column
          ), //Container
        ), //SingleChildScrollView
      ); //Scaffold
    }
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        //backgroundColor: bgColor,
        elevation: 20,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: bgColor,
      body: FutureBuilder<List<SongModel>>(
        //default values
        future: _audioQuery.querySongs(
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          //loading content indicator
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //no songs found
          if (item.data!.isEmpty) {
            return const Center(
              child: Text("No Songs Found"),
            );
          }

          // You can use [item.data!] direct or you can create a list of songs as
          // List<SongModel> songs = item.data!;
          //showing the songs
          songs.clear();
          songs = item.data!;
          return ListView.builder(
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 5.0, left: 0, right: 0),
                  decoration: BoxDecoration(
                    color: bgColor,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4.0,
                        offset: Offset(-4, -4),
                        color: Colors.white24,
                      ),
                      BoxShadow(
                        blurRadius: 10.0,
                        offset: Offset(4, 4),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  child: ListTile(
                    textColor: Colors.black,
                    title: Text(item.data![index].title),
                    subtitle: Text(
                      item.data![index].displayName,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    trailing: const Icon(Icons.more_vert),
                    leading: QueryArtworkWidget(
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                    ),
                    onTap: () async {
                      _changePlayerVisibility();
                      await _player.setAudioSource(createPlayerList(item.data!),
                          initialIndex: index);
                      await _player.play();
                    },
                  ),
                );
              });
        },
      ),
    );
  }

  //define a toast method
  void toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
    ));
  }

  void requestStoragePermission() async {
    //only if the platform is not web, coz web have no permissions
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }

      //ensure build method is called
      setState(() {});
    }
  }

  //create playList
  ConcatenatingAudioSource createPlayerList(List<SongModel> songs) {
    List<AudioSource> sources = [];
    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  //update playing song details
  void _updateCurrentPLayingSongDetails(int index) {
    setState(() {
      if (songs.isNotEmpty) {
        currentSongTitle = songs[index].title;
        currentIndex = index;
      }
    });
  }

  BoxDecoration getDecoration(
      BoxShape shape, Offset offset, double blurRadius, double spreadRadius) {
    return BoxDecoration(color: bgColor, shape: shape, boxShadow: [
      BoxShadow(
        offset: -offset,
        color: Colors.blue,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      ),
      BoxShadow(
        offset: offset,
        color: Colors.black,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      )
    ]);
  }

  BoxDecoration getRectDecoration(BorderRadius borderRadius, Offset offset,
      double blurRadius, double spreadRadius) {
    return BoxDecoration(
        borderRadius: borderRadius,
        color: bgColor,
        boxShadow: [
          BoxShadow(
            offset: -offset,
            color: Colors.blue,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
          BoxShadow(
            offset: offset,
            color: Colors.black,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          )
        ]);
  }
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
