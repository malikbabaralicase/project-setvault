import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/workout_session_model.dart';

class WorkoutAutosaveService {
  static const String _autosaveKey = 'setvault_active_workout_autosave';

  static Future<void> saveWorkout(WorkoutSessionModel session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(session.toMap());
      await prefs.setString(_autosaveKey, jsonStr);
    } catch (_) {}
  }

  static Future<WorkoutSessionModel?> loadUnfinishedWorkout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_autosaveKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final Map<String, dynamic> map = jsonDecode(jsonStr);
        final session = WorkoutSessionModel.fromMap(map);
        if (session.status == WorkoutStatus.inProgress || !session.isCompleted) {
          return session;
        }
      }
    } catch (_) {}
    return null;
  }

  static Future<void> clearAutosave() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_autosaveKey);
    } catch (_) {}
  }
}

