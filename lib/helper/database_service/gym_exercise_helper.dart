import 'dart:convert';

import 'package:achieve/exercises/gym_exercise.dart';
import 'package:http/http.dart' as http;

import '../helper.dart';

class GymExerciseHelper {
  static const Duration _timeToUpdate = Duration(days: 7);
  static const String exercisesLastUpdate = 'EXERCISES_LAST_UPDATE';
  static const String _exercisesToName = 'EXERCISES_TO_NAME';

  static Future<Map<String, GymExercise>> getGymExercises() async {
    Map<String, GymExercise> _listOfExercises = {};
    String? _lastUpdated = await Helper.getString(exercisesLastUpdate);
    if (_lastUpdated != null) {
      DateTime _date = DateTime.parse(_lastUpdated);
      if (_date.difference(DateTime.now()) > _timeToUpdate) { //todo should be >
        _listOfExercises =
            await _downloadAllExercises(exercisesLastUpdate, _exercisesToName);
      } else {
        String? _exercises = await Helper.getString(
            _exercisesToName); //_shared.getString('UPDATED_LAST');
        Map<String, dynamic> _map = json.decode(_exercises!);
        for (String x in _map.keys) {
          _listOfExercises[x] = GymExercise.fromJson(_map[x]);
        }
      }
    } else {
      _listOfExercises =
          await _downloadAllExercises(exercisesLastUpdate, _exercisesToName);
    }
    return _listOfExercises;
  }
  static Future<List<String>> getBodyParts() async {
    const String _bodyPartsLastUpdate = 'BODY_PARTS_LU';
    const String _bodyParts = 'BODY_PARTS';
    const String _bp = 'Body Parts';
    List<String> _s = [];
    String? _lastUpdated = await Helper.getString(_bodyPartsLastUpdate);
    if (_lastUpdated != null) {
      DateTime _date = DateTime.parse(_lastUpdated);
      if (_date.difference(DateTime.now()) > _timeToUpdate) {
        _s = await _downLoad(_bodyPartsLastUpdate, _bodyParts, _bp);
      } else {
        String? s = await Helper.getString(_bodyParts);
        if (s != null) {
          List<dynamic>? _exercises = jsonDecode(s);
          List<String> _bodyParts = [];
          for (dynamic x in _exercises!) {
            _bodyParts.add(x.toString());
          }
          return _bodyParts;
        }
      }
    } else {
      _s = await _downLoad(_bodyPartsLastUpdate, _bodyParts, _bp);
    }
    return _s;
  }
  static Future<List<String>> getMuscleTargets() async {
    const String _muscleTargetsLU = 'MUSCLE_TARGETS_LU';
    const String _muscleTargets = 'MUSCLE_TARGETS';
    const String _mT = 'Muscle Targets';

    List<String> _s = [];
    String? _lastUpdated = await Helper.getString(
        _muscleTargetsLU); //_shared.getString('MUSCLE_TARGETS_DATE');
    if (_lastUpdated != null) {
      DateTime _date = DateTime.parse(_lastUpdated);
      if (_date.difference(DateTime.now()) > _timeToUpdate) {
        _s = await _downLoad(_muscleTargetsLU, _muscleTargets, _mT);
      } else {
        String? s = await Helper.getString(
            _muscleTargets); //_shared.getString('MUSCLE_TARGETS');
        if (s != null) {
          List<dynamic>? _exercises = jsonDecode(s);
          List<String> _muscleTargets = [];
          for (dynamic x in _exercises!) {
            _muscleTargets.add(x.toString());
          }
          return _muscleTargets;
        }
      }
    } else {
      _s = await _downLoad(_muscleTargetsLU, _muscleTargets, _mT);
    }
    return _s;
  }

  static Future<List<String>> getEquipment() async {
    const String _equiptmentLU = 'EQUIPMENT_LU';
    const String _equipmentTarget = 'EQUIPMENT_TARGETS';
    const String _eq = 'Equipment';

    List<String> _s = [];
    String? _lastUpdated = await Helper.getString(_equiptmentLU);
    if (_lastUpdated != null) {
      DateTime _date = DateTime.parse(_lastUpdated);
      if (_date.difference(DateTime.now()) > _timeToUpdate) {
        _s = await _downLoad(_equiptmentLU, _equipmentTarget, _eq);
      } else {
        String? s = await Helper.getString(_equipmentTarget);
        if (s != null) {
          List<dynamic>? _equipment = jsonDecode(s);
          List<String> _equipmentList = [];
          for (dynamic x in _equipment!) {
            _equipmentList.add(x.toString());
          }
          return _equipmentList;
        }
      }
    } else {
      _s = await _downLoad(_equiptmentLU, _equipmentTarget, _eq);
    }
    return _s;
  }
}

Future<List<String>> _downLoad(
    String keyTime, String keyValues, String getting) async {
  List<String> _listOfInfo = [];
  switch (getting) {
    case 'Body Parts':
      _listOfInfo = await APIService().getBodyParts();
      break;
    case 'Equipment':
      _listOfInfo = await APIService().listOfEquipment();
      print(_listOfInfo);
      break;
    case 'Muscle Targets':
      _listOfInfo = await APIService().getMuscleTargets();
      break;
  }
  Helper.saveString(keyTime, DateTime.now().toString());
  Helper.saveString(keyValues, jsonEncode(_listOfInfo));
  return _listOfInfo;
}

Future<Map<String, GymExercise>> _downloadAllExercises(
    String exercisesLastUpdate, String _exercisesToName) async {
  final _listOfExercises = await APIService().getExercises();
  // _shared.setString('UPDATED_LAST_DATE', DateTime.now().toString());
  Helper.saveString(exercisesLastUpdate, DateTime.now().toString());
  //_shared.setString('UPDATED_LAST', jsonEncode(_listOfExercises));
  Helper.saveString(_exercisesToName, jsonEncode(_listOfExercises));
  return _listOfExercises;
}

class APIService {
  static const _authority = "exercisedb.p.rapidapi.com";
  static const _exercises = "/exercises";
  static const _bodyPart = "/exercises/bodyPartList";
  static const _targetMuscels = "/exercises/targetList";
  static const _listOfEquipment = "/exercises/equipmentList";
  static const Map<String, String> _headers = {
    "x-rapidapi-key": "67e1dc9766mshf42537bd2c7994bp154ba6jsn159a34d700ae",
    "x-rapidapi-host": "exercisedb.p.rapidapi.com",
  };

  // Base API request to get response
  Future<Map<String, GymExercise>> getExercises() async {
    //Future<String> getData() async {
    Uri uri = Uri.https(_authority, _exercises);
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      List<dynamic> jsonMap = jsonDecode(response.body);
      Map<String, GymExercise> _listOFEx = {};
      print(jsonMap.elementAt(0));
      for (dynamic x in jsonMap) {
        //_listOFEx.add(GymExercise.fromJson(x));
        final _ex = GymExercise.fromJson(x);
        _listOFEx[_ex.name] = _ex;
      }
      return _listOFEx;
    } else {
      // If that response was not OK, throw an error.
      throw Exception(
          'API call returned: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  //listOfEquipment
  Future<List<String>> listOfEquipment() async {
    Uri uri = Uri.https(_authority, _listOfEquipment);
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      List<dynamic> jsonMap = jsonDecode(response.body);
      List<String> _bodyParts = [];
      for (dynamic x in jsonMap) {
        _bodyParts.add(x.toString());
      }
      return _bodyParts;
    } else {
      throw Exception(
          'API call returned: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future<List<String>> getBodyParts() async {
    Uri uri = Uri.https(_authority, _bodyPart);
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      List<dynamic> jsonMap = jsonDecode(response.body);
      List<String> _bodyParts = [];
      for (dynamic x in jsonMap) {
        _bodyParts.add(x.toString());
      }
      return _bodyParts;
    } else {
      throw Exception(
          'API call returned: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future<List<String>> getMuscleTargets() async {
    print('downloaded bodyparts');
    Uri uri = Uri.https(_authority, _targetMuscels);
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      List<dynamic> jsonMap = jsonDecode(response.body);
      List<String> _bodyParts = [];
      for (dynamic x in jsonMap) {
        _bodyParts.add(x.toString());
      }
      return _bodyParts;
    } else {
      // If that response was not OK, throw an error.
      print('error');
      throw Exception(
          'API call returned: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
