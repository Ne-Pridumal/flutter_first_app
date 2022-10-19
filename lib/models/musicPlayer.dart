import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayer extends ChangeNotifier {
  List<SongModel> _songs = [];
  List<SongModel> _currentSongsList = [];
  int _currentSongIndex = 0;
  bool _musicPermission = false;
  final AudioPlayer _player = AudioPlayer();

  set musicPermission(bool res) {
    _musicPermission = res;
    notifyListeners();
  }

  bool get getMusicPermission {
    return _musicPermission;
  }

  set songsList(List<SongModel> newList) {
    _songs = newList;
    notifyListeners();
  }

  List<SongModel> get songs {
    return _songs;
  }

  set currentSongsList(List<SongModel> newList) {
    _currentSongsList.clear();
    _currentSongsList = newList;
    notifyListeners();
  }

  List<SongModel> get currentSongs {
    return _currentSongsList;
  }

  set currentSongIndex(int newIndex) {
    _currentSongIndex = newIndex;
    notifyListeners();
  }

  int get currentSongId {
    return _currentSongIndex;
  }

  bool isCurrentSongsEmpty() {
    return _currentSongsList.isEmpty;
  }

  AudioPlayer get player {
    return _player;
  }

  setMusic() async {
    if (_currentSongsList.isNotEmpty) {
      await _player.setAudioSource(
          AudioSource.uri(Uri.parse(_currentSongsList[_currentSongIndex].uri!)),
          initialIndex: _currentSongIndex);
      await _player.setShuffleModeEnabled(false);
      await _player.play();
      notifyListeners();
    }
  }

  stopMusic() {
    _player.stop();
    notifyListeners();
  }

  playMusic() {
    _player.play();
    notifyListeners();
  }

  shuffleAll() async {
    await _player.setAudioSource(
        AudioSource.uri(Uri.parse(_songs[_currentSongIndex].uri!)),
        initialIndex: _currentSongIndex);
    await _player.setShuffleModeEnabled(true);
    await _player.play();
  }
}
