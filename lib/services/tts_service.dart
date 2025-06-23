import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _isInitialized = false;

  TTSService() {
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.awaitSpeakCompletion(true);
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.5); // Slower rate for better clarity
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      _isInitialized = true;
    } catch (e) {
      print('Error initializing TTS: $e');
      _isInitialized = false;
    }
  }

  void setCompletionHandler(VoidCallback handler) {
    _flutterTts.setCompletionHandler(handler);
  }

  bool isSpeaking() {
    return _isSpeaking;
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await _initTts();
    }

    if (!_isSpeaking && _isInitialized) {
      _isSpeaking = true;
      try {
        await _flutterTts.speak(text);
      } catch (e) {
        print('Error speaking text: $e');
        _isSpeaking = false;
      }
    }
  }

  Future<void> stop() async {
    if (_isInitialized) {
      try {
        await _flutterTts.stop();
      } catch (e) {
        print('Error stopping TTS: $e');
      }
    }
    _isSpeaking = false;
  }

  void dispose() {
    if (_isInitialized) {
      _flutterTts.stop();
    }
  }
}
