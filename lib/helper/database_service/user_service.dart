import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import '../../user/LocalUser.dart';
import '../helper.dart';


class UserService {
  static String PROFILE_PIC = 'PROFILE_PIC';
  static Future<TaskSnapshot> uploadUserImageToServer(LocalUser _user, File _img){
    final _metaData = SettableMetadata(contentType: 'image/jpeg');
    final _s = FirebaseStorage.instance.ref().child('profiles').child(_user.userID).child('profile_pic');
    return _s.putFile(_img, _metaData);
  }
  static Future<File?> getProfileImage(String _id) async {
    String? _downloadUrl = await Helper.getString(PROFILE_PIC);
    if(_downloadUrl!=null){
      try {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        File _downloadFile = File('${appDocDir.path}/profile.jpg');
        await FirebaseStorage.instance.refFromURL(_downloadUrl).writeToFile(_downloadFile);
        return _downloadFile;
      } on FirebaseException catch(e) {
        print(e);
      }
    }
    return null;
  }
}
