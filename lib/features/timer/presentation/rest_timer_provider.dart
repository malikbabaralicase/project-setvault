import 'dart:async';
import 'package:flutter/material.dart';

class RestTimerProvider extends ChangeNotifier {
  int _initialSeconds = 90; // Default 01:30
  int _remainingSeconds = 90;
  bool _isRunning = false;
  Timer? _timer;

  int get initialSeconds => _initialSeconds;
  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;

  double get progressFraction {
    if (_initialSeconds == 0) return 0.0;
    return (_remainingSeconds / _initialSeconds).clamp(0.0, 1.0);
  }

  String get formattedTime {
    final int minutes = _remainingSeconds ~/ 60;
    final int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    if (_isRunning) return;
    _isRunning = true;
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        pauseTimer();
      }
    });
  }

  void pauseTimer() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void toggleTimer() {
    if (_isRunning) {
      pauseTimer();
    } else {
      startTimer();
    }
  }

  void resetTimer() {
    pauseTimer();
    _remainingSeconds = _initialSeconds;
    notifyListeners();
  }

  void setPreset(int seconds) {
    pauseTimer();
    _initialSeconds = seconds;
    _remainingSeconds = seconds;
    notifyListeners();
  }

  void adjustTime(int deltaSeconds) {
    _remainingSeconds = (_remainingSeconds + deltaSeconds).clamp(0, 3600);
    if (_remainingSeconds > _initialSeconds) {
      _initialSeconds = _remainingSeconds;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
