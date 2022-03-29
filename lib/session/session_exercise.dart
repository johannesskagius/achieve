import 'package:achieve/exercises/exercise.dart';

class SessionExercise {
  final Exercise exercise;
  String set;
  String reps;
  int posInSess;

  SessionExercise(this.exercise, this.set, this.reps, this.posInSess);

  factory SessionExercise.fromJson(dynamic json) =>
      _sessionExerciseFromJson(json);

  Map<String, dynamic> toJson() => {
        'exercise': exercise,
        'set': set,
        'reps': reps,
        'position': posInSess,
      };
}

SessionExercise _sessionExerciseFromJson(dynamic json) {
  return SessionExercise(
      json['exercise'], json['set'], json['reps'], json['position']);
}
