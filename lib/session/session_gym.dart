import 'package:achieve/session/session.dart';

import 'session_exercise.dart';

class GymSession extends Session {
  @override
  String id;
  @override
  String desc;
  @override
  String name;
  @override
  int time;
  List<SessionExercise> _exerciseInfo;

  GymSession(this.id, this.desc, this.name, this.time, this._exerciseInfo);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'desc': desc,
        'name': name,
        'time': time,
        'exercises': _exerciseInfo,
      };

  factory GymSession.fromJson(dynamic json) => _fromJson(json);

  @override
  void addSessionFeedback() {
    // TODO: implement addSessionFeedback
  }

  @override
  void removeSession() {
    // TODO: implement removeSession
  }

  @override
  void updateSession() {
    // TODO: implement updateSession
  }

  @override
  void uploadSession() {
    // TODO: implement uploadSession
  }
}

GymSession _fromJson(dynamic json) {
  return GymSession(
      json['id'], json('desc'), json['name'], json['time'], json['exercises']);
}
