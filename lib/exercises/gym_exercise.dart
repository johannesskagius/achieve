import 'package:achieve/exercises/exercise.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/database_service/database_ref.dart';
import '../helper/database_service/user_service.dart';
import '../helper/helper.dart';
import 'gym_res.dart';

class GymExercise extends Exercise {
  static const String _maxRepsStats = 'mReps';
  static const String _maxWeightStats = 'mWeight';
  static const String _maxWeightPerRepsRation = 'ratio';
  final Map<String, String> _stats = {};
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
  int _mRep = 0;
  double _mWeight = 0;
  double _mRatio = 0;

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
  Future<Map<int, Map<String, String>>?> addExerciseResult(
      BuildContext context) async {
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

  Widget showStatsRow() {
    return _stats.isNotEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('PB ' + _stats[_maxWeightStats].toString()),
              Text('Reps ' + _stats[_maxRepsStats].toString()),
              Text('Ratio ' + _stats[_maxWeightPerRepsRation].toString()),
            ],
          )
        : const Center(child: SizedBox.shrink());
  }

  @override
  void setExerciseResult(String _setNo, Map<String, String> _result) {
    String _id = References.firebaseAuth.currentUser!.uid;
    final _date = Helper.getTodayDateMonthYear();
    UserService.exerciseRef(_id, name).child('occasion').child(_date)
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

  Map<String, bool> checkIfPB(double _weight, int _rep) {
    Map<String, bool> _res = {};
    if (_weight > _mWeight) {
      _mWeight = _weight;
      _res[_maxWeightStats] = true;
    }
    if(_rep > _mRep){
      _mRep = _rep;
      _res[_maxRepsStats] = true;
    }
    double _ratio = (_weight/_rep);
    if(_ratio > _mRatio){
      _mRatio = _ratio;
      _res[_maxWeightPerRepsRation] = true;
    }
    return _res;
  }

  @override
  Future<void> exerciseStats() async {
    String _id = References.firebaseAuth.currentUser!.uid;
    final _dataSnapshot =
        await UserService.exerciseRef(_id, name).child('stats').get();
    if (_dataSnapshot.value == null) {
      return;
    }
    for (DataSnapshot _d in _dataSnapshot.children) {
      switch (_d.key.toString()) {
        case _maxWeightStats:
          _mWeight = double.parse(_d.value.toString());
          break;
        case _maxRepsStats:
          _mRep = int.parse(_d.value.toString());
          break;
        case _maxWeightPerRepsRation:
          _mRatio = double.parse(_d.value.toString());
          break;
      }
      _stats.putIfAbsent(_d.key.toString(), () => _d.value.toString());
    }
  }
}

GymExercise _fromJson(dynamic json) {
  return GymExercise(json['bodyPart'], json['equipment'], json['id'],
      json['name'], json['target'], json['gifUrl']);
}
