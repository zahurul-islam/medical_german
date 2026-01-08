/// Audio Service for playing vocabulary and dialogue audio
import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  String? _currentlyPlayingUrl;
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;
  String? get currentlyPlayingUrl => _currentlyPlayingUrl;

  /// Play audio from asset path
  /// audioUrl format: "assets/audio/sections/section_XX/vocabulary/v01_01.mp3"
  Future<void> playAudio(String audioUrl) async {
    try {
      // Stop any currently playing audio
      await stop();

      _currentlyPlayingUrl = audioUrl;
      _isPlaying = true;

      // Check if it's an asset path
      if (audioUrl.startsWith('assets/')) {
        // Load from asset
        await _player.setAsset(audioUrl);
      } else if (audioUrl.startsWith('http')) {
        // Load from URL
        await _player.setUrl(audioUrl);
      } else {
        // Assume it's an asset path without prefix
        await _player.setAsset('assets/$audioUrl');
      }

      // Play the audio
      await _player.play();
      
      // Listen for completion
      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
          _currentlyPlayingUrl = null;
        }
      });
    } catch (e) {
      print('Error playing audio: $e');
      _isPlaying = false;
      _currentlyPlayingUrl = null;
      // Don't throw - just fail silently for missing audio files
    }
  }

  /// Stop currently playing audio
  Future<void> stop() async {
    try {
      await _player.stop();
      _isPlaying = false;
      _currentlyPlayingUrl = null;
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  /// Pause currently playing audio
  Future<void> pause() async {
    try {
      await _player.pause();
      _isPlaying = false;
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  /// Resume paused audio
  Future<void> resume() async {
    try {
      await _player.play();
      _isPlaying = true;
    } catch (e) {
      print('Error resuming audio: $e');
    }
  }

  /// Check if a specific audio is currently playing
  bool isPlayingUrl(String audioUrl) {
    return _isPlaying && _currentlyPlayingUrl == audioUrl;
  }

  /// Dispose the player
  void dispose() {
    _player.dispose();
  }
}



