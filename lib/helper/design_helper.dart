import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../user/log_in.dart';

class DesignHelper {
  static EdgeInsets standardInsets() {
    return const EdgeInsets.all(8);
  }

  static Text Header(String _title) {
    return Text(
      _title,
      style: const TextStyle(), //TODO set textStyle
    );
  }

  static TextStyle iosAlertBuilder(){
    return const TextStyle(
      color: Colors.white
    );
  }

  static TextStyle buttonStandard(){
    return const TextStyle( );
  }

  static TextStyle barelyVisible(){
    return const TextStyle(
      color: Colors.white30,
    );
  }

  static Divider dividerStd(){
    return const Divider(height: 1);
  }

  static CupertinoButton _cupertinoBtn(String _text, function()){
    return CupertinoButton(child: Text(_text), onPressed: function());
  }


  static CupertinoAlertDialog cupertinoAlertDialog(BuildContext context, String _title){
    return CupertinoAlertDialog(
      title: const Text('Create an account'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LogIn(true)));
            },
            child: const Text('Yes')),
        TextButton(
            onPressed: () {
              print('Explain');
              Navigator.pop(context);
            },
            child: const Text('No')),
      ],
    );
  }

  static double stdElevation(){
    return 10;
  }

  static AlertDialog alertDialog(BuildContext context){
    return AlertDialog(
      title: const Text('Create an account'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LogIn(false)));
            },
            child: const Text('Yes')),
        TextButton(
            onPressed: () {
              print('Explain');
              //todo set timer until comes up again
              Navigator.pop(context);
            },
            child: const Text('No')),
      ],
    );
  }
}
