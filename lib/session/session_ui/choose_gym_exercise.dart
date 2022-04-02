import 'package:achieve/exercises/gym_exercise.dart';
import 'package:achieve/helper/database_service/gym_exercise_helper.dart';
import 'package:flutter/material.dart';

import 'gym_ex_desc.dart';

class ChooseGymExercise extends StatefulWidget {
  const ChooseGymExercise({Key? key}) : super(key: key);

  @override
  _ChooseGymExerciseState createState() => _ChooseGymExerciseState();
}

class _ChooseGymExerciseState extends State<ChooseGymExercise> {
  Map<String, GymExercise> _all = {};
  List<GymExercise> _suggestedExercises = [];
  Map<String, Object> _chosenExercises = {};

  List<String> _bodyParts = [];
  List<bool> _selectedBP = [];
  Set<String> _bodyPartsToInvolve = {};

  List<String> _muscleTargets = [];
  List<bool> _selectedMT = [];
  Set<String> _musclesToInvolve = {};

  List<String> _equipment = [];
  List<bool> _selectedEquip = [];
  Set<String> _equipmentToInvolve = {};

  Future<void> _getExercises() async {
    _all = await GymExerciseHelper.getGymExercises();
    _bodyParts.add('Body Parts');
    _bodyParts.addAll(await GymExerciseHelper.getBodyParts());
    _selectedBP = List.generate(_bodyParts.length, (index) => false);

    _muscleTargets.add('Muscle Targets');
    _muscleTargets.addAll(await GymExerciseHelper.getMuscleTargets());
    _selectedMT = List.generate(_muscleTargets.length, (index) => false);

    _equipment.add('Equipment');
    _equipment.addAll(await GymExerciseHelper.getEquipment());
    _selectedEquip = List.generate(_equipment.length, (index) => false);
    setState(() {});
  }

  @override
  void initState() {
    _getExercises();
    super.initState();
  }

  void onTapped(String _t, int index, String s) {
    switch (_t) {
      case 'BP':
        if (!_selectedBP.elementAt(index)) {
          _selectedBP[index] = true;
          _bodyPartsToInvolve.add(s);
        } else {
          _selectedBP[index] = false;
          _bodyPartsToInvolve.remove(s);
        }
        break;
      case 'MT':
        if (!_selectedMT.elementAt(index)) {
          _selectedMT[index] = true;
          _musclesToInvolve.add(s);
        } else {
          _selectedMT[index] = false;
          _musclesToInvolve.remove(s);
        }
        break;
      case 'EQ':
        if (!_selectedEquip.elementAt(index)) {
          _selectedEquip[index] = true;
          _equipmentToInvolve.add(s);
        } else {
          _selectedEquip[index] = false;
          _equipmentToInvolve.remove(s);
        }
        break;
    }
    _updateExercises();
    setState(() {});
  }

  Future<void> _updateExercises() async {
    _suggestedExercises.clear();
    for (GymExercise _current in _all.values) {
      if (_bodyPartsToInvolve.isEmpty ||
          !_bodyPartsToInvolve.contains(_current.bodyPart)) {
        _suggestedExercises.add(_current);
        if (_musclesToInvolve.isNotEmpty &&
            !_musclesToInvolve.contains(_current.type)) {
          _suggestedExercises.remove(_current);
        }
        if (_equipmentToInvolve.isNotEmpty &&
            !_equipmentToInvolve.contains(_current.equipment)) {
          _suggestedExercises.remove(_current);
        }
      }
    }
  }

  SizedBox _selectors(
      String _s, double _width, List<String> _list, List<bool> _selected) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: _list.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => {
              onTapped(_s, index, _list.elementAt(index)),
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                    color: _selected.elementAt(index)
                        ? Colors.red
                        : Colors.white38,
                    border: Border.all(width: 1, color: Colors.black38)),
                alignment: Alignment.center,
                width: 100,
                child: Text(_list.elementAt(index)),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Exercises'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _selectors('BP', _width, _bodyParts, _selectedBP),
            _selectors('MT', _width, _muscleTargets, _selectedMT),
            _selectors('EQ', _width, _equipment, _selectedEquip),
            Expanded(
                child: _suggestedExercises.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: _suggestedExercises.length,
                        itemBuilder: (BuildContext context, int index) {
                          final _ex = _suggestedExercises.elementAt(index);
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(context, _ex);
                              },
                              onLongPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GymExerciseDescribed(_ex)));
                              },
                              title: Text(_ex.name),
                              trailing: Text(_ex.type),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text('add your first Exercise'),
                      )),
          ],
        ),
      ),
    );
  }
}
