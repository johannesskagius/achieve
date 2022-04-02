import 'dart:async';

import 'package:achieve/helper/design_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'helper/helper.dart';
import 'session/session_gym.dart';
import 'session/session_ui/gym_session.dart';

class Free extends StatefulWidget {
  const Free({Key? key}) : super(key: key);

  @override
  State<Free> createState() => _FreeState();
}

class _FreeState extends State<Free> {
  List<String> _joiningFriends = [];
  String _time = 'Date';
  late Timer _timer;

  void _sendToNext(String _title){
    switch(_title){
      case 'Gym':
        Navigator.push(context, MaterialPageRoute(builder: (context) => GymSessionUI(DateTime.now())));
        break;
      case 'Swim':
        break;
      case 'Bike':
        break;
      case 'Run':
        break;
      case 'Yoga':
        break;
      case 'Dance':
        break;
    }
  }
  GestureDetector _sport(String _title, String _assetImg) {
    return GestureDetector(
      onTap: (){
        _sendToNext(_title);
      },
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(_assetImg))),
                  padding: const EdgeInsets.all(8),
                )),
            FittedBox(
              alignment: Alignment.bottomCenter,
              child: Text(_title),
            )
          ],
        ),
      ),
    );
  }

  void _startTimer(){
    _time = Helper.getTimeHourMin();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _time = Helper.getTimeHourMin();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height-AppBar().preferredSize.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(width: _width * 0.3,height: _height*0.1, child: FittedBox(child: Text(_time))),
            Expanded(
              child: SingleChildScrollView(
                child: CustomScrollView(
                  shrinkWrap: true,
                  primary: false,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverGrid.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        children: [
                          _sport('Gym', 'assets/images/gym.png'),
                          _sport('Swim', 'assets/images/crawl.png'),
                          _sport('Run', 'assets/images/run.png'),
                          _sport('Bike', 'assets/images/bike.png'),
                          _sport('Yoga', 'assets/images/yoga.png'),
                          _sport('Cross country skiing',
                              'assets/images/cskiing.png'),
                          _sport('Step dance', 'assets/images/sdance.png'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: _height*0.1,
              child: Row(
                children: [
                 _isIOS ? CupertinoButton(
                      child: const Icon(CupertinoIcons.person_add),
                      onPressed: () {

                      }):TextButton(onPressed: (){}, child: const Icon(Icons.supervisor_account_outlined)),
                  Text(
                    'Add friends',
                    style: DesignHelper.barelyVisible(),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
void showAlert(bool _ios){

}