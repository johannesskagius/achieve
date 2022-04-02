import 'package:achieve/exercises/gym_exercise.dart';
import 'package:achieve/helper/design_helper.dart';
import 'package:flutter/material.dart';

class GymExerciseDescribed extends StatelessWidget {
  const GymExerciseDescribed(this._ex, {Key? key}) : super(key: key);
  final GymExercise _ex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_ex.name),
      ),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(_ex.url),
            ),
            const Divider(),
            Text('Exercise info:', style: DesignHelper.barelyVisible(),),
            Card(
              child: SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Name:', style: DesignHelper.barelyVisible()),
                    FittedBox(child: Text(_ex.name),),
                  ],
                ),
              )
            ),
            Card(
                child: SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Body Part:', style: DesignHelper.barelyVisible()),
                      FittedBox(child: Text(_ex.bodyPart),),
                    ],
                  ),
                )
            ),
            Card(
                child: SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Target Muscle:', style: DesignHelper.barelyVisible()),
                      FittedBox(child: Text(_ex.type)),
                    ],
                  ),
                )
            ),
            Card(
                child: SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Equipment:', style: DesignHelper.barelyVisible()),
                      FittedBox(child: Text(_ex.equipment)),
                    ],
                  ),
                )
            ),
            Card(
                child: SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Thoughness:', style: DesignHelper.barelyVisible()),
                      const FittedBox(child: Text('1-5')),
                    ],
                  ),
                )
            ),
            const Divider(),
            Text('Own stats:', style: DesignHelper.barelyVisible(),),
            Card(
                child: SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Heaviest:', style: DesignHelper.barelyVisible()),
                      const FittedBox(child: const Text('45kg')),
                    ],
                  ),
                )
            ),
            Card(
                child: SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Last Time:', style: DesignHelper.barelyVisible()),
                      const FittedBox(child: Text('Date')),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
