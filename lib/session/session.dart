

import 'package:achieve/session/session_exercise.dart';

abstract class Session {
  late String id,name;
  late String? desc;
  late int time;
  abstract Map<String, List<SessionExercise>> _exerciseInfo;

  Map<String, dynamic> toJson();
  void updateSession();
  void uploadSession();
  void removeSession();
  void addSessionFeedback();

  @override
  String toString() {
    return 'name: $name, time: $time, _exerciseInfo: '+ _exerciseInfo.length.toString();
  }
}