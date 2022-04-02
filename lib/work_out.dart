import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'free.dart';
import 'helper/helper.dart';

class WorkOut extends StatelessWidget {
  const WorkOut(this._isIOS, {Key? key}) : super(key: key);
  final bool _isIOS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isIOS ? const IOS() : const Else(),
    );
  }
}

class IOS extends StatefulWidget {
  const IOS({Key? key}) : super(key: key);

  @override
  _IOSState createState() => _IOSState();
}

class _IOSState extends State<IOS> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
        child: SafeArea(
            child: Container(
      margin: const EdgeInsets.all(8),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                    width: _width * 0.4, child: FittedBox(child: Text(Helper.getTodayDateAndMonth()))),
                SizedBox(
                    width: _width * 0.4,
                    child:
                        const FittedBox(child: Text('Perfect for a workout'))),
              ],
            ),
            CupertinoButton(
                child: const Text('Lets go'),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const Free()));
                })
          ],
        ),
      ),
    )));
  }
}

class Else extends StatefulWidget {
  const Else({Key? key}) : super(key: key);

  @override
  _ElseState createState() => _ElseState();
}

class _ElseState extends State<Else> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.all(8),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                    width: _width * 0.4, child: FittedBox(child: Text(Helper.getTodayDateAndMonth()))),
                SizedBox(
                    width: _width * 0.4,
                    child:
                        const FittedBox(child: Text('Perfect for a workout'))),
              ],
            ),
            TextButton(
                child: const Text('Lets go'),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const Free()));
                })
          ],
        ),
      ),
    ));
  }
}
