import 'dart:async';
import 'dart:io';

import 'package:achieve/exercises/exercise.dart';
import 'package:achieve/helper/database_service/database_ref.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../../user/LocalUser.dart';
import '../helper.dart';

class UserService {
  static const String profilePic = 'PROFILE_PIC';
  static const String _userRes = 'res';

  static DatabaseReference exerciseRef (String uId, String name){
    return References.usersRef.child(uId).child(_userRes).child(name);
  }

  static Future<TaskSnapshot> uploadUserImageToServer(
      LocalUser _user, File _img) {
    final _metaData = SettableMetadata(contentType: 'image/jpeg');
    final _s = FirebaseStorage.instance
        .ref()
        .child('profiles')
        .child(_user.userID)
        .child('profile_pic');
    return _s.putFile(_img, _metaData);
  }

  static Future<File?> getProfileImage(String _id) async {
    String? _downloadUrl = await Helper.getString(profilePic);
    if (_downloadUrl != null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      File _downloadFile = File('${appDocDir.path}/profile.jpg');
      await FirebaseStorage.instance
          .refFromURL(_downloadUrl)
          .writeToFile(_downloadFile);
      return _downloadFile;
    }
    return null;
  }
}
