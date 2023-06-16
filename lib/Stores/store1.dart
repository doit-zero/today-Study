import 'dart:async';
import 'package:flutter/material.dart';

class Store1 extends ChangeNotifier {
  int totalSeconds = 0;
  Timer? timer;
  String buttonName = 'Start';
  bool isRunning = false;

  clicked() {
    if (isRunning == false) {
      onStartPressed();
    } else {
      onPuasePressed();
    }
    notifyListeners();
  }

  onStartPressed() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      totalSeconds++;
      buttonName = 'Stop';
      isRunning = true;
      notifyListeners();
    });
  }

  onPuasePressed() {
    timer?.cancel();
    buttonName = 'Start';
    isRunning = false;
    notifyListeners();
  }

  reset() {
    totalSeconds = 0;
    notifyListeners();
  }

// 0:00:00 에
  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first;
  }
}
