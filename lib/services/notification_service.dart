import 'package:just_audio/just_audio.dart';
import 'dart:async';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer;

  Future<void> initialize() async {
    // Initialize audio player
    await _audioPlayer.setAsset('assets/sounds/alarm.mp3');
    await _audioPlayer.setLoopMode(LoopMode.one);
  }

  void scheduleMedicineReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) {
    final now = DateTime.now();
    final duration = scheduledTime.difference(now);

    if (duration.isNegative) {
      return; // Skip if time has already passed
    }

    _timer?.cancel();
    _timer = Timer(duration, () {
      playAlarmSound();
      showDialog(title: title, body: body);
    });
  }

  Future<void> playAlarmSound() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing alarm sound: $e');
    }
  }

  Future<void> stopAlarmSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error stopping alarm sound: $e');
    }
  }

  void showDialog({required String title, required String body}) {
    // This will be handled by the UI layer
  }

  void cancelAllReminders() {
    _timer?.cancel();
    stopAlarmSound();
  }

  void cancelNotification(int id) {
    _timer?.cancel();
    stopAlarmSound();
  }

  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
  }
}
