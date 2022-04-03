import 'package:achieve/exercises/exercise.dart';
import 'package:achieve/exercises/gym_exercise.dart';

class SessionExercise {
  final Exercise exercise;
  String set;
  List<double> reps;
  int posInSess;
  int? rest;

  SessionExercise(this.exercise, this.set, this.reps, this.rest, this.posInSess);

  factory SessionExercise.fromJson(dynamic json) =>
      _sessionExerciseFromJson(json);

  Map<String, dynamic> toJson() => {
        'exercise': exercise.toJson(),
        'set': set,
        'reps': reps,
        'rest': rest,
        'position': posInSess,
      };


  @override
  bool operator == (Object other) =>
      identical(this, other) ||
      other is SessionExercise &&
          runtimeType == other.runtimeType &&
          exercise == other.exercise &&
          posInSess == other.posInSess;

  @override
  int get hashCode => exercise.hashCode ^ posInSess.hashCode;

  @override
  String toString() {
    return 'SessionExercise{exercise: $exercise, set: $set, posInSess: $posInSess}';
  }
}

SessionExercise _sessionExerciseFromJson(dynamic json) {
  return SessionExercise(
      GymExercise.fromJson(json['exercise']), json['set'], json['reps'], json['rest'],json['position']);
}
