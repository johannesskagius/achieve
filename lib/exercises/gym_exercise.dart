import 'package:achieve/exercises/exercise.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/database_service/database_ref.dart';
import '../helper/database_service/user_service.dart';
import '../helper/helper.dart';
import 'gym_res.dart';

class GymExercise extends Exercise {
  final String bodyPart;
  final String equipment;
  @override
  String id;
  @override
  String name;
  @override
  String type;
  @override
  String url;

  GymExercise(
      this.bodyPart, this.equipment, this.id, this.name, this.type, this.url);

  factory GymExercise.fromJson(dynamic json) => _fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'bodyPart': bodyPart,
        'equipment': equipment,
        'name': name,
        'target': type,
        'gifUrl': url,
      };

  @override
  Future<Map<int, Map<String, String>>?> addExerciseResult(BuildContext context) async {
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => GymRes(this)));
  }

  @override
  void getExerciseResult() {
    // TODO: implement getExerciseResult
  }

  @override
  String toString() {
    return 'GymExercise{bodyPart: $bodyPart, name: $name}';
  }

  @override
  void setExerciseResult(String _setNo, Map<String, String> _result) {
    String _id = References.firebaseAuth.currentUser!.uid;
    final _date = Helper.getTodayDateMonthYear();
    //UserService.exerciseRef(_id, name).child(_date).set('t');
    UserService.exerciseRef(_id, name).child(_date)
      ..update({'f': 't'})
      ..update({_setNo: _result});
  }

  void removeSet(int _setNo) {
    String _id = References.firebaseAuth.currentUser!.uid;
    final _date = Helper.getTodayDateMonthYear();
    UserService.exerciseRef(_id, name)
        .child(_date)
        .child(_setNo.toString())
        .remove();
  }
}

GymExercise _fromJson(dynamic json) {
  return GymExercise(json['bodyPart'], json['equipment'], json['id'],
      json['name'], json['target'], json['gifUrl']);
}
