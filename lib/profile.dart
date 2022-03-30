import 'dart:io';

import 'package:achieve/helper/design_helper.dart';
import 'package:achieve/user/LocalUser.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile(this._img, {Key? key}) : super(key: key);
  File _img;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height-AppBar().preferredSize.height;
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: IconButton(
                    onPressed: () {},
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
                      const Expanded(child: FittedBox(child: Text('Profile Name', textAlign: TextAlign.center,))),
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
                Container(margin: const EdgeInsets.all(8),child: const Text('Training Stats')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
