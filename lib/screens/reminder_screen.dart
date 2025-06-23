import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../colors/colors.dart';
import '../services/notification_service.dart';
import 'dart:async';
import 'package:flutter_locales/flutter_locales.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final List<Map<String, dynamic>> _reminders = [];
  final NotificationService _notificationService = NotificationService();
  final Map<int, Timer> _activeTimers = {};

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  @override
  void dispose() {
    _cancelAllTimers();
    super.dispose();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
  }

  void _cancelAllTimers() {
    for (var timer in _activeTimers.values) {
      timer.cancel();
    }
    _activeTimers.clear();
  }

  void _startTimer(int index, TimeOfDay time) {
    // Cancel existing timer if any
    _activeTimers[index]?.cancel();

    // Calculate time until reminder
    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final duration = scheduledTime.difference(now);

    // Schedule notification
    _notificationService.scheduleMedicineReminder(
      id: index,
      title: 'Medicine Reminder',
      body: 'Time to take ${_reminders[index]['name']}!',
      scheduledTime: scheduledTime,
    );

    // Start countdown timer
    _activeTimers[index] = Timer(duration, () {
      _handleTimerComplete(index);
    });

    // Update reminder with scheduled time
    setState(() {
      _reminders[index]['scheduledTime'] = scheduledTime;
    });
  }

  void _handleTimerComplete(int index) {
    if (_reminders[index]['isActive']) {
      _notificationService.playAlarmSound();
      // Show dialog to confirm medicine taken
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(Locales.string(context, 'medicine_reminder')),
              content: Text(
                '${Locales.string(context, 'time_to_take_medicine')}${_reminders[index]['name']}!',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _notificationService.stopAlarmSound();
                    Navigator.of(context).pop();
                    // Reschedule for next day
                    _startTimer(index, _reminders[index]['time']);
                  },
                  child: Text(Locales.string(context, 'ill_take_it_now')),
                ),
              ],
            ),
      );
    }
  }

  void _addReminderForTimeAndName(TimeOfDay time, String name) {
    setState(() {
      final index = _reminders.length;
      _reminders.add({'time': time, 'name': name, 'isActive': true});
      _startTimer(index, time);
    });
  }

  void _toggleReminder(int index) {
    setState(() {
      _reminders[index]['isActive'] = !_reminders[index]['isActive'];
      if (_reminders[index]['isActive']) {
        _startTimer(index, _reminders[index]['time']);
      } else {
        _activeTimers[index]?.cancel();
        _notificationService.cancelNotification(index);
      }
    });
  }

  void _deleteReminder(int index) {
    _activeTimers[index]?.cancel();
    _notificationService.cancelNotification(index);
    setState(() {
      _reminders.removeAt(index);
    });
  }

  Future<void> _showAddReminderDialog(BuildContext context) async {
    TimeOfDay? pickedTime;
    String medicineName = '';
    String? validationMessage;
    final nameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(Locales.string(context, 'add_reminder')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: Locales.string(context, 'medicine_name'),
                    ),
                    onChanged: (value) {
                      medicineName = value;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          pickedTime = picked;
                        });
                      }
                    },
                    icon: Icon(Icons.access_time),
                    label: Text(
                      pickedTime == null
                          ? Locales.string(context, 'pick_time')
                          : Locales.string(context, 'change_time'),
                    ),
                  ),
                  if (pickedTime != null) ...[
                    SizedBox(height: 8),
                    Text(
                      '${Locales.string(context, 'selected_time')}'
                      '${pickedTime!.hour.toString().padLeft(2, '0')}:${pickedTime!.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                  if (validationMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        validationMessage ?? '',
                        style: TextStyle(color: Colors.redAccent, fontSize: 14),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(Locales.string(context, 'cancel')),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (medicineName.isEmpty) {
                      setState(() {
                        validationMessage = Locales.string(
                          context,
                          'please_enter_medicine_name',
                        );
                      });
                    } else if (pickedTime == null) {
                      setState(() {
                        validationMessage = Locales.string(
                          context,
                          'please_pick_time',
                        );
                      });
                    } else {
                      // If both are valid, add the reminder
                      _addReminderForTimeAndName(pickedTime!, medicineName);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(Locales.string(context, 'add')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getTimeUntilReminder(DateTime scheduledTime) {
    final now = DateTime.now();
    final difference = scheduledTime.difference(now);

    if (difference.isNegative) {
      return Locales.string(context, 'overdue');
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours ${Locales.string(context, 'h')} $minutes${Locales.string(context, 'm')}';
    } else {
      return '$minutes ${Locales.string(context, 'min')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        title: Text(
          Locales.string(context, 'reminders'),
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Drug'),
        ),
      ),
      body:
          _reminders.isEmpty
              ? Center(child: Text(Locales.string(context, 'no_reminders_yet')))
              : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  final reminder = _reminders[index];
                  final time = reminder['time'] as TimeOfDay;
                  final isActive = reminder['isActive'] as bool;
                  final name = reminder['name'] as String;
                  final scheduledTime = reminder['scheduledTime'] as DateTime?;

                  return Card(
                    margin: EdgeInsets.only(bottom: 8),
                    color: isDarkMode ? AppColors.darkPrimary : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.access_time,
                        color: isActive ? AppColors.accentColor : Colors.grey,
                      ),
                      title: Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              isActive
                                  ? (isDarkMode
                                      ? Colors.white
                                      : AppColors.textDark)
                                  : Colors.grey,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color:
                                  isActive
                                      ? (isDarkMode
                                          ? Colors.white70
                                          : AppColors.textDark.withOpacity(0.7))
                                      : Colors.grey,
                            ),
                          ),
                          if (isActive && scheduledTime != null)
                            Text(
                              '${Locales.string(context, 'next_reminder_in')}${_getTimeUntilReminder(scheduledTime)}',
                              style: TextStyle(
                                color: AppColors.accentColor,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: isActive,
                            onChanged: (value) => _toggleReminder(index),
                            activeColor: AppColors.accentColor,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline),
                            onPressed: () => _deleteReminder(index),
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminderDialog(context),
        backgroundColor: AppColors.accentColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
