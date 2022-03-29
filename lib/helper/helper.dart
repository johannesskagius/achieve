import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static String _getToday() {
    final now = DateTime.now();
    String month = now.month.toString();
    if (now.month < 10) {
      month = '0' + now.month.toString();
    }
    return now.day.toString() + month + now.year.toString();
  }

  static void saveString(String _key, String _value) async {
    final _shared = await SharedPreferences.getInstance();
    _shared.setString(_key, _value);
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
