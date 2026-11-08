import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/exercise_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/workout_routine_model.dart';
import '../../data/models/workout_session_model.dart';
import '../../data/models/workout_set_model.dart';
import 'firebase_service.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  FirebaseFirestore? get _db => FirebaseService().firestore;

  // Local memory cache for instant UI rendering and offline fallback
  final Map<String, List<WorkoutSessionModel>> _localWorkoutCache = {};
  final Map<String, List<WorkoutRoutineModel>> _localRoutineCache = {};
  final Map<String, List<ExerciseModel>> _localCustomExercises = {};

  // ==========================================
  // USER PROFILE
  // users/{uid}/profile/info
  // ==========================================

  Future<void> saveUserProfile(String uid, UserModel user) async {
    final db = _db;
    if (db != null) {
      await db
          .collection('users')
          .doc(uid)
          .collection('profile')
          .doc('info')
          .set(user.toMap(), SetOptions(merge: true));
    }
  }

  Future<UserModel?> getUserProfile(String uid) async {
    final db = _db;
    if (db != null) {
      final doc = await db
          .collection('users')
          .doc(uid)
          .collection('profile')
          .doc('info')
          .get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
    }
    return null;
  }

  // ==========================================
  // WORKOUT LOGGING & HIERARCHY
  // users/{uid}/workouts/{workoutId}/exercises/{exerciseId}/sets/{setId}
  // ==========================================

  Future<void> saveWorkoutSession(
    String uid,
    WorkoutSessionModel session,
  ) async {
    // 1. Update local cache
    final userWorkouts = _localWorkoutCache.putIfAbsent(uid, () => []);
    userWorkouts.removeWhere((w) => w.id == session.id);
    userWorkouts.insert(0, session);

    // 2. Persist to Firestore if available
    final db = _db;
    if (db != null) {
      final batch = db.batch();
      final workoutRef = db
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .doc(session.id);

      // Save workout document
      batch.set(workoutRef, {
        'id': session.id,
        'title': session.title,
        'date': session.date.toIso8601String(),
        'durationSeconds': session.durationSeconds,
        'totalSets': session.totalSets,
        'totalVolumeKg': session.totalVolumeKg,
        'notes': session.notes,
        'status': session.status.name,
        'syncStatus': SyncStatus.synced.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Save exercises & sets subcollections
      for (final ex in session.exercises) {
        final exRef = workoutRef.collection('exercises').doc(ex.id);
        batch.set(exRef, {
          'id': ex.id,
          'exerciseId': ex.exercise.id,
          'exerciseName': ex.exercise.name,
          'muscleGroup': ex.exercise.muscleGroup,
          'note': ex.note,
        });

        for (final s in ex.sets) {
          final setRef = exRef.collection('sets').doc(s.id);
          batch.set(setRef, s.toMap());
        }
      }

      await batch.commit();
    }
  }

  Future<List<WorkoutSessionModel>> getWorkoutSessions(
    String uid, {
    int limit = 50,
  }) async {
    final db = _db;
    if (db != null) {
      try {
        final querySnapshot = await db
            .collection('users')
            .doc(uid)
            .collection('workouts')
            .orderBy('date', descending: true)
            .limit(limit)
            .get();

        final List<WorkoutSessionModel> sessions = [];
        for (final doc in querySnapshot.docs) {
          final data = doc.data();
          // Load exercises subcollection
          final exSnapshot = await doc.reference.collection('exercises').get();
          final List<ExerciseInWorkout> exercises = [];

          for (final exDoc in exSnapshot.docs) {
            final exData = exDoc.data();
            final setsSnapshot = await exDoc.reference.collection('sets').get();
            final List<WorkoutSetModel> sets = setsSnapshot.docs
                .map((s) => WorkoutSetModel.fromMap(s.data()))
                .toList();
            sets.sort((a, b) => a.setNumber.compareTo(b.setNumber));

            exercises.add(
              ExerciseInWorkout(
                id: exData['id'] as String? ?? exDoc.id,
                exercise: ExerciseModel(
                  id: exData['exerciseId'] as String? ?? '',
                  name: exData['exerciseName'] as String? ?? 'Exercise',
                  muscleGroup: exData['muscleGroup'] as String? ?? 'Chest',
                  equipment: 'Standard',
                  personalBest: '',
                  lastPerformance: '',
                  instructions: '',
                  performanceHistory: [],
                ),
                sets: sets,
                note: exData['note'] as String?,
              ),
            );
          }

          sessions.add(
            WorkoutSessionModel(
              id: doc.id,
              title: data['title'] as String? ?? 'Workout',
              date: DateTime.tryParse(data['date'] as String? ?? '') ??
                  DateTime.now(),
              durationSeconds: (data['durationSeconds'] as num?)?.toInt() ?? 0,
              exercises: exercises,
              notes: data['notes'] as String?,
              isCompleted: true,
              status: WorkoutStatus.completed,
              syncStatus: SyncStatus.synced,
            ),
          );
        }

        if (sessions.isNotEmpty) {
          _localWorkoutCache[uid] = sessions;
          return sessions;
        }
      } catch (e) {
        // Fallback to local cache on offline / connectivity issue
      }
    }

    return _localWorkoutCache[uid] ?? [];
  }

  // ==========================================
  // DYNAMIC LAST-TIME / CARRY-OVER CALCULATION
  // ==========================================

  Future<List<WorkoutSetModel>?> getPreviousExercisePerformance(
    String uid,
    String exerciseId,
  ) async {
    final sessions = await getWorkoutSessions(uid);
    for (final session in sessions) {
      for (final ex in session.exercises) {
        if (ex.exercise.id == exerciseId && ex.sets.isNotEmpty) {
          return ex.sets;
        }
      }
    }
    return null;
  }

  // ==========================================
  // ROUTINES HIERARCHY
  // users/{uid}/routines/{routineId}/exercises/{exerciseId}
  // ==========================================

  Future<void> saveRoutine(String uid, WorkoutRoutineModel routine) async {
    final routines = _localRoutineCache.putIfAbsent(uid, () => []);
    routines.removeWhere((r) => r.id == routine.id);
    routines.add(routine);

    final db = _db;
    if (db != null) {
      final routineRef = db
          .collection('users')
          .doc(uid)
          .collection('routines')
          .doc(routine.id);

      await routineRef.set(routine.toMap());
    }
  }

  Future<List<WorkoutRoutineModel>> getRoutines(String uid) async {
    final db = _db;
    if (db != null) {
      try {
        final querySnapshot =
            await db.collection('users').doc(uid).collection('routines').get();
        final routines = querySnapshot.docs
            .map((doc) => WorkoutRoutineModel.fromMap(doc.data()))
            .toList();
        if (routines.isNotEmpty) {
          _localRoutineCache[uid] = routines;
          return routines;
        }
      } catch (_) {}
    }
    return _localRoutineCache[uid] ?? [];
  }

  Future<void> deleteRoutine(String uid, String routineId) async {
    _localRoutineCache[uid]?.removeWhere((r) => r.id == routineId);
    final db = _db;
    if (db != null) {
      await db
          .collection('users')
          .doc(uid)
          .collection('routines')
          .doc(routineId)
          .delete();
    }
  }

  // ==========================================
  // CUSTOM EXERCISES
  // users/{uid}/customExercises/{exerciseId}
  // ==========================================

  Future<void> saveCustomExercise(String uid, ExerciseModel exercise) async {
    final customList = _localCustomExercises.putIfAbsent(uid, () => []);
    customList.removeWhere((e) => e.id == exercise.id);
    customList.add(exercise);

    final db = _db;
    if (db != null) {
      await db
          .collection('users')
          .doc(uid)
          .collection('customExercises')
          .doc(exercise.id)
          .set(exercise.toMap());
    }
  }

  Future<List<ExerciseModel>> getCustomExercises(String uid) async {
    final db = _db;
    if (db != null) {
      try {
        final query = await db
            .collection('users')
            .doc(uid)
            .collection('customExercises')
            .get();
        final list = query.docs
            .map((doc) => ExerciseModel.fromMap(doc.data()))
            .toList();
        if (list.isNotEmpty) {
          _localCustomExercises[uid] = list;
          return list;
        }
      } catch (_) {}
    }
    return _localCustomExercises[uid] ?? [];
  }

  Future<void> deleteCustomExercise(String uid, String exerciseId) async {
    _localCustomExercises[uid]?.removeWhere((e) => e.id == exerciseId);
    final db = _db;
    if (db != null) {
      await db
          .collection('users')
          .doc(uid)
          .collection('customExercises')
          .doc(exerciseId)
          .delete();
    }
  }

  // ==========================================
  // SETTINGS & PREFERENCES
  // users/{uid}/settings/preferences
  // ==========================================

  Future<void> saveSettings(
    String uid,
    Map<String, dynamic> preferences,
  ) async {
    final db = _db;
    if (db != null) {
      await db
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('preferences')
          .set(preferences, SetOptions(merge: true));
    }
  }
}

