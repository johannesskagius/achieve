import 'dart:io';

import 'package:achieve/helper/design_helper.dart';
import 'package:achieve/helper/helper.dart';
import 'package:achieve/user/LocalUser.dart';
import 'package:flutter/material.dart';

import 'settings.dart';

class Profile extends StatefulWidget {
  Profile(this._img, {Key? key}) : super(key: key);
  File _img;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _name = 'Profile Name';
  void _getPName() async{
    String? _pName = await Helper.getString('PNAME');
    if(_pName != null){
      _name = _pName;
    }
  }
  @override
  void initState() {
    _getPName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height-AppBar().preferredSize.height;
    bool _isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Settings(_isIOS)));
                    },
                    icon: const Icon(Icons.settings_outlined))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: DesignHelper.stdElevation(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: _height*0.10,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            onTap: ()=>{
                              print('update'),
                            },
                            child: CircleAvatar(
                              foregroundImage: Image.file(widget._img).image,
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: FittedBox(child: Text(_name, textAlign: TextAlign.center))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(margin: const EdgeInsets.all(8),child: const Text('Create a workout plan')),
                Container(margin: const EdgeInsets.all(8),child: const Text('Followers')),
                Container(margin: const EdgeInsets.all(8),child: const Text('Training Stats')),
                Container(margin: const EdgeInsets.all(8),child: const Text('Sessions this year')),
                Container(margin: const EdgeInsets.all(8),child: const Text('Activities')),
                Container(margin: const EdgeInsets.all(8),child: const Text('Posts')),
                Container(margin: const EdgeInsets.all(8),child: const Text('Gear')),
                Container(margin: const EdgeInsets.all(8),child: const Text('Classes')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
