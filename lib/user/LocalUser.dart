
import 'package:achieve/helper/database_service/database_ref.dart';

import '../helper/helper.dart';

class LocalUser {
  final String userID;
  String? _email;
  String? pName, _password;
  Map<String, List<String>> _associates = {}; // key for coaches, one key for friends

  LocalUser(this.userID, this._email, this.pName, this._password){
    _createUserProfile();
  }
  void _createUserProfile(){
    References.usersRef.child(userID).set(1);
  }

  void saveUser() {
    Helper.saveString('USER_ID', userID);
    if (_email != null && _password != null) {
      Helper.saveString('PASSWORD', _password!);
      Helper.saveString('EMAIL', _email!);
    }
    if(pName != null){
      Helper.saveString('PNAME', pName!);
    }
  }

  static void signIn() async {
    String? _password = await Helper.getString('PASSWORD');
    String? _email = await Helper.getString('EMAIL');

    if (_email != null && _password != null) {
      await References.firebaseAuth
          .signInWithEmailAndPassword(email: _email, password: _password);
    }
  }

  static void signOut() async {
    Helper.removeValue('PASSWORD');
    Helper.removeValue('PASSWORD');
    References.firebaseAuth.signOut();
    References.firebaseAuth.signInAnonymously();
  }

  String getUserID() {
    String s = Helper.getString('USER_ID').toString();
    return s;
  }
}
