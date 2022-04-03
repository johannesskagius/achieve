import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Helper {
  static String getTimeHourMin(){
    final _date = DateTime.now();
    String _hour ='';
    String _min ='';
    if(_date.hour < 10){
      _hour = '0'+ _date.hour.toString();
    }else{
      _hour = _date.hour.toString();
    }
    if(_date.minute < 10){
      _min = '0'+_date.minute.toString();
    } else{
      _min = _date.minute.toString();
    }
    return _hour+':'+_min;
  }

  static bool isIos(BuildContext context){
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  /// Hours and minutes
  /// compared to current dime
  static int getTimeDifferenceInMinutes(DateTime x){
    final _now = DateTime.now();
    Duration _duration = _now.difference(x);
    return _duration.inMinutes;
  }

  static String getTimeHourMinFromDateTime(DateTime _time){
    final _date = _time;
    String _hour ='';
    String _min ='';
    if(_date.hour < 10){
      _hour = '0'+ _date.hour.toString();
    }else{
      _hour = _date.hour.toString();
    }
    if(_date.minute < 10){
      _min = '0'+_date.minute.toString();
    } else{
      _min = _date.minute.toString();
    }
    return _hour+':'+_min;
  }

  static String getTodayDayMonth() {
    final now = DateTime.now();
    String month = now.month.toString();
    if (now.month < 10) {
      month = '0' + now.month.toString();
    }
    return now.day.toString() + month;
  }

  static String getTodayDateMonthYear() {
    final now = DateTime.now();
    String month = now.month.toString();
    if (now.month < 10) {
      month = '0' + now.month.toString();
    }
    return now.day.toString() + month + now.year.toString();
  }

  static String getTodayDateAndMonth() {
    final now = DateTime.now();
    String month = now.month.toString();
    if (now.month < 10) {
      month = '0' + now.month.toString();
    }
    return now.day.toString() +' '+ _getMonth(month);
  }
  static String _getMonth(String _month) {
    switch (_month) {
      case '01':
        return 'January';
      case '02':
        return 'February';
      case '03':
        return 'Mars';
      case '04':
        return 'April';
      case '05':
        return 'May';
      case '06':
        return 'June';
      case '07':
        return 'July';
      case '08':
        return 'August';
      case '09':
        return 'September';
      case '10':
        return 'October';
      case '11':
        return 'November';
      case '12':
        return 'December';
    }
    return '';
  }

  static void saveString(String _key, String _value) async {
    final _shared = await SharedPreferences.getInstance();
    _shared.setString(_key, _value);
  }

  static void removeValue(String _key) async {
    final _shared = await SharedPreferences.getInstance();
    _shared.remove(_key);
  }

  static Future<String?> getString(String _key) async {
    final _shared = await SharedPreferences.getInstance();
    String? _test =  _shared.getString(_key);
    return _test;
  }

  static void unFocus(){
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
  }


  static Future<XFile?> showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Choose option'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Gallery'),
                    leading: const Icon(Icons.photo_album_outlined),
                    onTap: () async{
                      Navigator.pop(context, await _galleryImage(context));
                    },
                  ),
                  ListTile(
                    title: const Text('Camera'),
                    leading: const Icon(Icons.camera_alt_outlined),
                    onTap: () async{
                      Navigator.pop(context, await _cameraImage(context));
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  static Future<XFile?> _galleryImage(BuildContext c) async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  static Future<XFile?> _cameraImage(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    return pickedFile;
  }
}
