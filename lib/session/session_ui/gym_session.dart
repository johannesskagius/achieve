import 'dart:async';

import 'package:achieve/exercises/exercise.dart';
import 'package:achieve/helper/database_service/database_ref.dart';
import 'package:achieve/helper/database_service/user_service.dart';
import 'package:achieve/helper/design_helper.dart';
import 'package:achieve/session/session_exercise.dart';
import 'package:achieve/session/session_gym.dart';
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
  Map<SessionExercise, List<double>> _exercises =
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
                            List<double> _reps = [];
                            List<double> _resWeights = [];
                            for (Map<String, String> _setNo in _res.values) {
                              String? _repsNo = _setNo['reps'];
                              String? _weight = _setNo['weight'];
                              if (_repsNo != null) {
                                _reps.add(double.parse(_repsNo));
                              }
                              if (_weight != null) {
                                _resWeights.add(double.parse(_weight));
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
                        return GestureDetector(
                          child: Card(
                            child: ListTile(
                              leading: Text((_ex.posInSess).toString()),
                              title: Text(_ex.exercise.name),
                              trailing: Text(
                                  _exercises[_ex]!.first.toInt().toString() +
                                      ' - ' +
                                      _exercises[_ex]!.last.toInt().toString() +
                                      'kg'),
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
                      onPressed: () async {
                        final _controller = TextEditingController();
                        String _title ='Well done!';
                        return _isIOS ? showCupertinoDialog(context: context, builder: (context)=> CupertinoAlertDialog(
                          title: Text(_title),
                          content: CupertinoTextField(
                            keyboardType: TextInputType.name,
                            controller: _controller,
                            style: DesignHelper.iosAlertBuilder(),
                            prefix:
                            Text('Reps', style: DesignHelper.barelyVisible()),
                          ),
                          actions: [
                            CupertinoButton(
                                child: const Text('I´m not done'),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            CupertinoButton(
                                child: const Text('I´m done'),
                                onPressed: () {
                                  _addSession(_controller);
                                  //Navigator.pop(context);
                                })
                          ],
                        )) : showDialog(context: context, builder: (context) => AlertDialog(
                          title: Text(_title),
                          content: TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _controller,
                            style: DesignHelper.iosAlertBuilder(),
                          ),
                          actions: [
                            TextButton(
                                child: const Text('I´m not done'),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            TextButton(
                                child: const Text('I´m done'),
                                onPressed: () {
                                  _addSession(_controller);
                                  Navigator.pop(context);
                                })
                          ],
                        ));
                      })
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

  void _addSession(TextEditingController _controller) {
   String _name = _controller.value.text;
    if(_name.isNotEmpty){
      //create and save session
      int _min  = Helper.getTimeDifferenceInMinutes(widget._startTime);
      String _id = References.firebaseAuth.currentUser!.uid;
      final _ref = UserService.ownSessionRef(_id);
      _id += ','+_name;
      print(_exercises.keys.elementAt(0).toString());
       List<SessionExercise> _list = [];
       _list.addAll(_exercises.keys.toList());
       final _session = GymSession(_id, null,_name, _min, _list);
       _ref.child(_name).set(_session.toJson());
    }
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
  String _time = 'START !';

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
