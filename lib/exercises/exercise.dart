

import 'package:flutter/cupertino.dart';

abstract class Exercise{
  abstract String id;
  abstract String name, type, url;
  Map<String, dynamic> toJson();
  Future<Map<int, Map<String, String>>?> addExerciseResult(BuildContext context);
  void getExerciseResult();
  void setExerciseResult(String setNo, Map<String, String> _result);

  @override
  String toString() {
    return 'Exercise{}';
  }
}