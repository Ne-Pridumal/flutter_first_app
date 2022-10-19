import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayer {
  static OnAudioQuery audioQuery = OnAudioQuery();
  static List<SongModel> songs = [];
  static List<SongModel> currentSongsList = [];
  static int currentSongIndex = 0;
  static bool musicPermission = false;

  static void checkMusicPermission() async {
    if (!kIsWeb) {
      bool permissionaStatus = await audioQuery.permissionsStatus();
      if (!permissionaStatus) {
        await audioQuery.permissionsRequest();
      }
    }
  }

  static void setNewCurrentSongsList(List<SongModel> newList) {
    currentSongsList.clear();
    currentSongsList = newList;
  }
}
