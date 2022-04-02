import 'dart:async';

import 'package:achieve/exercises/exercise.dart';
import 'package:achieve/helper/design_helper.dart';
import 'package:achieve/session/session_exercise.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helper/helper.dart';
import 'choose_gym_exercise.dart';

class GymSessionUI extends StatefulWidget {
  const GymSessionUI(this._startTime, {Key? key}) : super(key: key);
  final DateTime _startTime;

  @override
  _GymSessionUIState createState() => _GymSessionUIState();
}

class _GymSessionUIState extends State<GymSessionUI> {
  String _startTime = '';
  Map<SessionExercise, List<String>> _exercises =
      {}; // key exercise in session, value is the results

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _isIOS = Helper.isIos(context);
    final _width = MediaQuery.of(context).size.width;
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                  width: _width * 0.5,
                  child: const FittedBox(child: Text('Lets kill it'))),
              SizedBox(
                  width: _width * 0.3,
                  child: const FittedBox(child: Text('Training Time:'))),
              ElapsedTime(_width * 0.2),
              _isIOS
                  ? CupertinoButton(
                      child: const Icon(CupertinoIcons.add_circled),
                      onPressed: () async {
                        Exercise? _ex = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ChooseGymExercise()));
                        if (_ex == null) {
                          return;
                        } else {
                          Map<int, Map<String, String>>? _res =
                              await _ex.addExerciseResult(context);
                          if (_res != null) {
                            List<String> _reps = [];
                            List<String> _resWeights = [];
                            for (Map<String, String> _setNo in _res.values) {
                              String? _repsNo = _setNo['reps'];
                              String? _weight = _setNo['weight'];
                              if (_repsNo != null) {
                                _reps.add(_repsNo);
                              }
                              if (_weight != null) {
                                _resWeights.add(_weight);
                              }
                            }
                            final _sessionEx = SessionExercise(
                                _ex,
                                _res.keys.length.toString(),
                                _reps,
                                null,
                                _exercises.keys.length);
                            _exercises[_sessionEx] = _resWeights;
                          }
                          setState(() {});
                        }
                      })
                  : TextButton(
                      onPressed: () {},
                      child: const Icon(Icons.plus_one_outlined)),
              _exercises.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                      itemCount: _exercises.keys.length,
                      itemBuilder: (BuildContext context, int index) {
                        final _ex = _exercises.keys.elementAt(index);
                        return index == 0
                            ? Container(
                                margin: const EdgeInsets.all(8),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('No:',
                                          style: DesignHelper.barelyVisible()),
                                      Text('exercise name:',
                                          style: DesignHelper.barelyVisible()),
                                      Text('Reps:',
                                          style: DesignHelper.barelyVisible())
                                    ]),
                              )
                            : GestureDetector(
                                child: Card(
                                  child: ListTile(
                                    leading: Text((_ex.posInSess).toString()),
                                    title: Text(_ex.exercise.name),
                                    trailing: Text(_ex.reps.first),
                                  ),
                                ),
                              );
                      },
                    ))
                  : const Center(
                      child: Text('add first exercise'),
                    ),
              _isIOS
                  ? CupertinoButton(
                      child: Text('Completed',
                          style: DesignHelper.buttonStandard()),
                      onPressed: () {})
                  : TextButton(
                      onPressed: () {},
                      child: Text('Completed',
                          style: DesignHelper.buttonStandard()))
            ],
          ),
        ),
      ),
    );
  }
}

class ElapsedTime extends StatefulWidget {
  const ElapsedTime(this._width, {Key? key}) : super(key: key);
  final double _width;

  @override
  _ElapsedTimeState createState() => _ElapsedTimeState();
}

class _ElapsedTimeState extends State<ElapsedTime> {
  int _seconds = 0;
  int _min = 0;
  int _hours = 0;
  Timer? _timer;
  String _time = '';

  void _getTrainingTime() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        if (_seconds >= 60) {
          _seconds = 0;
          _min++;
          if (_min >= 60) {
            _min = 0;
            _hours++;
          }
        }
        _time = '';
        if (_hours != 0) {
          _time += _hours.toString() + 'h ';
        }
        if (_min != 0) {
          _time += _min.toString() + 'min ';
        }
        if (_seconds != 0) {
          _time += _seconds.toString() + 's';
        }
      });
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _getTrainingTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: widget._width,
          child: FittedBox(
              child: Text(
            _time,
            style: DesignHelper.barelyVisible(),
          )),
        )
      ],
    );
  }
}
