import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayer {
  static OnAudioQuery audioQuery = OnAudioQuery();
  static List<SongModel> songs = [];
  static SongModel? currentSong;
  static bool musicPermission = false;

  static void checkMusicPermission() async {
    if (!kIsWeb) {
      bool permissionaStatus = await audioQuery.permissionsStatus();
      if (!permissionaStatus) {
        await audioQuery.permissionsRequest();
      }
    }
  }
}
