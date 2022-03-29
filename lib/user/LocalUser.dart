import 'dart:convert';

import 'package:flutter/material.dart';

import '../helper/helper.dart';

class LocalUser{
  final String userID;
  String? _email;
  String? pName, _password;
  Map<String, List<String>> _associates = {};
  LocalUser(this.userID, this._email, this.pName, this._password);

  void saveUser(){
    Helper.saveString('USER_ID', userID);

    if(_email != null && _password != null){
      Helper.saveString('PASSWORD', _password!);
      Helper.saveString('EMAIL', _email!);
    }
  }
  void getUser()async{
    String? _user = await Helper.getString('USER_ID');
    if(_user != null){
      print(jsonDecode(_user));
    }
  }
}