import 'dart:async';

import 'package:achieve/exercises/gym_exercise.dart';
import 'package:achieve/helper/database_service/database_ref.dart';
import 'package:achieve/helper/design_helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/database_service/user_service.dart';
import '../helper/helper.dart';

class GymRes extends StatefulWidget {
  const GymRes(this._exercise, {Key? key}) : super(key: key);

  final GymExercise _exercise;

  @override
  _GymResState createState() => _GymResState();
}

class _GymResState extends State<GymRes> {
  final List<BarChartGroupData> _barData = [];
  List<FlSpot> _lineBarData = [];
  List<FlSpot> _today = [];
  double _maxY = 0;
  Map<String, List<double>> _barRes = {};
  final Map<String, List<double>> _lineChart = {};
  final Map<int, Map<String, String>> _res = {};
  final _pController = PageController();
  int _sets = 0;

  Future<void> _getData() async {
    widget._exercise.exerciseStats();
    String _id = References.firebaseAuth.currentUser!.uid;
    final _snapShot = await UserService.exerciseRef(_id, widget._exercise.name)
        .child('occasion')
        .get();
    for (DataSnapshot _date in _snapShot.children) {
      for (DataSnapshot _exercise in _date.children) {
        String _reps = '';
        for (DataSnapshot _ex in _exercise.children) {
          if (_ex.key == 'weight') {
            double y = double.parse(_ex.value.toString());
            _barRes.putIfAbsent(_date.key.toString(), () => []).add(y);
            if (_reps != '') {
              _lineChart.putIfAbsent(_reps, () => []).add(y);
              _reps = '';
            }
            if (y > _maxY) {
              _maxY = y;
            }
          } else {
            _reps = _ex.value.toString(); // nr of reps
          }
        }
      }
      if (_date.key.toString() == Helper.getTodayDateMonthYear()) {
        _sets++;
      }
      if (_barRes[_date.key.toString()] != null &&
          _barRes[_date.key.toString()]!.isNotEmpty) {
        _barData.add(_makeGroupData(
            int.parse(_date.key.toString()), _barRes[_date.key.toString()]));
      }
      _lineBarData = _lineData(_lineChart);
      setState(() {});
    }
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future<List<double>?> _getRes() async {
    final _textController = TextEditingController();
    final _controller2 = TextEditingController();
    String _title = 'Add result';
    bool _isIOS = Helper.isIos(context);
    return _isIOS
        ? await showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
                  title: Text(_title),
                  content: CupertinoFormSection(
                    children: [
                      CupertinoTextField(
                        controller: _textController,
                        prefix:
                            Text('Reps', style: DesignHelper.barelyVisible()),
                        keyboardType: TextInputType.number,
                        style: DesignHelper.iosAlertBuilder(),
                      ),
                      CupertinoTextField(
                        prefix:
                            Text('Weight', style: DesignHelper.barelyVisible()),
                        controller: _controller2,
                        keyboardType: TextInputType.number,
                        style: DesignHelper.iosAlertBuilder(),
                      ),
                    ],
                  ),
                  actions: [
                    CupertinoButton(
                        child: const Text('Back'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    CupertinoButton(
                        child: const Text('Add'),
                        onPressed: () {
                          List<double> _res = [];
                          _res.add(double.parse(_textController.value.text));
                          _res.add(double.parse(_controller2.value.text));
                          Navigator.pop(context, _res);
                        })
                  ],
                ))
        : await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Add res'),
                  content: Column(
                    children: [
                      TextFormField(
                        controller: _textController,
                        keyboardType: TextInputType.number,
                        style: DesignHelper.iosAlertBuilder(),
                      ),
                      TextFormField(
                        controller: _controller2,
                        keyboardType: TextInputType.number,
                        style: DesignHelper.iosAlertBuilder(),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                        child: const Text('Back'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    TextButton(
                        child: const Text('Add'),
                        onPressed: () {
                          List<double> _res = [];
                          _res.add(double.parse(_textController.value.text));
                          _res.add(double.parse(_controller2.value.text));
                          Navigator.pop(context, _res);
                        })
                  ],
                ));
  }

  @override
  Widget build(BuildContext context) {
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    LineDiagram _line = LineDiagram(_lineBarData, _today);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget._exercise.name),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
                height: _height * 0.5,
                child: _barData.isNotEmpty
                    ? PageView(
                        pageSnapping: true,
                        controller: _pController,
                        children: [
                          _line,
                          BarDiagram(_barData),
                        ],
                      )
                    : const Center(
                        child: Text('Add your first result'),
                      )),
          ),
          widget._exercise.showStatsRow(),
          CupertinoButton(
              child: const Text('Add set'),
              onPressed: () async {
                //get weight and reps
                List<double>? _addRes = await _getRes();
                if (_addRes == null || _addRes.isEmpty) {
                  return;
                }
                _addData(_addRes.elementAt(1), _addRes.elementAt(0));
                Map<String, bool> _pb = widget._exercise.checkIfPB(
                    _addRes.elementAt(1), _addRes.elementAt(0).toInt());

                // widget._exercise.setExerciseResult(_sets.toString(), {
                //   'reps': _addRes.elementAt(0).toString(),
                //   'weight': _addRes.elementAt(1).toString()
                // }); // add result to server
                _res.putIfAbsent(
                    // add result to send it back to gym_session
                    _sets,
                    () => {
                          'reps': _addRes.elementAt(0).toString(),
                          'weight': _addRes.elementAt(1).toString()
                        });
                _sets++; // add no of sets,
                //update to server
                setState(() {});
              }),
          CupertinoButton(
              child: const Text('Remove last set'),
              onPressed: () {
                //remove
                _barData.removeLast();
                _today.removeLast();
                //widget._exercise.removeSet(3);
                setState(() {});
              }),
          CupertinoButton(
              child: const Text('back'),
              onPressed: () {
                //remove
                Navigator.pop(context, _res);
                //widget._exercise.removeSet(3);
              }),
          CupertinoButton(
              child: const Text('get'),
              onPressed: () {
                //remove
                _getData();
                //widget._exercise.removeSet(3);
              }),
        ],
      ),
    );
  }

  void _addData(double _weight, double _reps) {
    _barData
        .add(_makeGroupData(int.parse(Helper.getTodayDayMonth()), [_weight]));
    _today.add(FlSpot(_reps, _weight));
  }
}

List<FlSpot> _lineData(Map<String, List<double>> _data) {
  List<FlSpot> _flSpots = [];
  for (String _repsString in _data.keys) {
    List<double>? _list = _data[_repsString];
    if (_list != null) {
      double _count = 0;
      int nr = 0;
      for (double _x in _list) {
        _count += _x;
        nr++;
      }
      double _avg = (_count / nr);
      double _reps = double.parse(_repsString);
      _flSpots.add(FlSpot(_reps, _avg));
    }
  }
  return _flSpots;
}

BarChartGroupData _makeGroupData(int _date, List<double>? _resOnDate) {
  List<BarChartRodData> _rods = []; // BarChartRodData(toY: y, width: 15)
  return BarChartGroupData(x: _date, barsSpace: 8, barRods: _rods);
}

class BarDiagram extends StatefulWidget {
  const BarDiagram(this._barData, {Key? key}) : super(key: key);
  final List<BarChartGroupData> _barData;

  @override
  _BarDiagramState createState() => _BarDiagramState();
}

class _BarDiagramState extends State<BarDiagram> {
  double _minY = double.maxFinite;
  double _maxY = 0;

  FlTitlesData _barTitles() {
    return FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
        )));
  }

  void _getRange() {
    for (BarChartGroupData _x in widget._barData) {
      for (BarChartRodData _xx in _x.barRods) {
        if (_xx.toY < _minY) {
          _minY = _xx.toY;
        }
        if (_xx.toY > _maxY) {
          _maxY = _xx.toY;
        }
      }
    }
  }

  @override
  void initState() {
    _getRange();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BarDiagram oldWidget) {
    _getRange();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: BarChart(BarChartData(
        maxY: (_maxY * 1.1).roundToDouble(),
        minY: (_minY * 0.9).roundToDouble(),
        barGroups: widget._barData,
        titlesData: _barTitles(),
      )),
    );
  }
}

class LineDiagram extends StatefulWidget {
  const LineDiagram(this._lineBarData, this._today, {Key? key})
      : super(key: key);
  final List<FlSpot> _lineBarData;
  final List<FlSpot> _today;

  @override
  _LineDiagramState createState() => _LineDiagramState();
}

class _LineDiagramState extends State<LineDiagram> {
  final String _saved = 'LINE_CHART';
  final List<LineChartBarData> _dataShow = [];
  double _minY = 100000;
  double _maxY = 0;
  double _maxX = 0;
  double _minX = double.maxFinite;

  FlTitlesData _barTitles() {
    return FlTitlesData(
        //12032022
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
            axisNameWidget: const Text('repetitions'),
            sideTitles: SideTitles(showTitles: true)));
  }

  void _sortFlSpots() {
    widget._lineBarData.sort((a, b) => a.x.compareTo(b.x));
  }

  void _setVisibleArea() {
    try {
      for (LineChartBarData _line in _dataShow) {
            if (_line.mostBottomSpot.y < _minY) {
              _minY = _line.mostBottomSpot.y;
            }
            if (_line.mostTopSpot.y > _maxY) {
              _maxY = _line.mostTopSpot.y;
            }
            if (_line.mostLeftSpot.x < _minX) {
              _minX = _line.mostLeftSpot.x;
            }
            if (_line.mostRightSpot.x > _maxX) {
              _maxX = _line.mostRightSpot.x;
            }
          }
    } catch (e) {
        _minX = 1;
        _maxX = 10;
        _minY = 0;
        _maxY = 50;
    }
  }

  @override
  void didUpdateWidget(covariant LineDiagram oldWidget) {
    _sortFlSpots();
    if (widget._today.isNotEmpty) {
      _dataShow.add(LineChartBarData(
        spots: widget._today,
        isCurved: true,
        barWidth: 3,
        color: Colors.green,
      ));
    }
    _setVisibleArea();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _sortFlSpots();
    _dataShow.add(LineChartBarData(
      spots: widget._lineBarData,
      isCurved: true,
      barWidth: 3,
      color: Colors.red.withOpacity(0.5),
    ));
    _setVisibleArea();
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: LineChart(
        LineChartData(
          maxY: (_maxY * 1.1).roundToDouble(),
          minY: (_minY * 0.8).roundToDouble(),
          maxX: (_maxX * 1.1).roundToDouble(),
          minX: _minX < 4 ? 1 : (_minX * 0.8).roundToDouble(),
          lineBarsData: _dataShow,
          titlesData: _barTitles(),
        ),
        swapAnimationDuration: const Duration(milliseconds: 150),
        swapAnimationCurve: Curves.linear,
      ),
    );
  }
}
