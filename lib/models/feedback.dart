class AppFeedback {
  final String message;
  final DateTime timestamp;

  AppFeedback({required this.message, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {'message': message, 'timestamp': timestamp.toIso8601String()};
  }
}
