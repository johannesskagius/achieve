import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class References {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
  static final DatabaseReference admin =   exerciseRef.child('admin');
  static final DatabaseReference sessionRef = FirebaseDatabase.instance.ref().child('sessions');
  static final DatabaseReference exerciseRef = FirebaseDatabase.instance.ref().child('exercises');
  static final DatabaseReference exerciseRefUser = exerciseRef.child('userMade');
  static final DatabaseReference exerciseRefStandard =   exerciseRef.child('standard');
  static final DatabaseReference improvementTips =   exerciseRef.child('improvement');

}
