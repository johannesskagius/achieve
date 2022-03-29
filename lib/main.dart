import 'package:achieve/helper/helper.dart';
import 'package:achieve/user/LocalUser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'helper/database_service/database_ref.dart';
import 'user/create_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
        overlays: [SystemUiOverlay.top]);
    return MaterialApp(
      theme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.blueGrey),
      home: BackGround(_isIOS),
    );
  }
}

class BackGround extends StatefulWidget {
  const BackGround(this._isIOS, {Key? key}) : super(key: key);
  final bool _isIOS;

  @override
  _BackGroundState createState() => _BackGroundState();
}

class _BackGroundState extends State<BackGround> {
  final _pController = PageController();
  bool isManager = false;
  int _selected = 0;

  void _checkUserStatus() async {
    final _auth = References.firebaseAuth;
    late LocalUser _user;

    _auth.userChanges().listen((event) {
      if (event == null) {
        _auth.signInAnonymously();
      } else {
        _user = LocalUser(event.uid, null, null, null);
        _user.saveUser();
        if (event.isAnonymous) {
          widget._isIOS
              ? showCupertinoDialog(
                  context: context,
                  builder: (context) => _cupertinoAlertDialog(context))
              : showDialog(
                  context: context,
                  builder: (context) => _alertDialog(context));
        } else {
          //load personal data;
          if (!event.emailVerified) {
            print('prompt to verify email');
          }
        }
      }
      print(event.toString());
    });
  }

  @override
  void initState() {
    _checkUserStatus();
    super.initState();
  }

  void onTapped(int index) {
    setState(() {
      _pController.animateToPage(index,
          duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    });
  }

  void _onPageChanged(int index) {
    Helper.unFocus();
    setState(() {
      _selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pController,
        pageSnapping: true,
        onPageChanged: _onPageChanged,
        children: [
          //Home(),
          //my courses,
          //OwnCoach,
          //Settings,
          //Admin
        ],
      ),
      bottomSheet: BottomNavigationBar(
        items: _bottomMenu,
        currentIndex: _selected,
        showSelectedLabels: true,
        selectedItemColor: Colors.greenAccent,
        onTap: onTapped,
      ),
    );
  }
}

List<BottomNavigationBarItem> _bottomMenu = [
  const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
  const BottomNavigationBarItem(
      icon: Icon(Icons.my_library_add_outlined), label: 'Courses'),
  const BottomNavigationBarItem(
      icon: Icon(Icons.star_border_outlined), label: 'Own coach'),
  BottomNavigationBarItem(
      icon: Image.asset('assets/logo/IconOnly_Transparent_NoBuffer_small.png',
          color: Colors.grey),
      activeIcon: Image.asset(
          'assets/logo/IconOnly_Transparent_NoBuffer_small.png',
          color: Colors.grey),
      label: 'Own coach'),
  const BottomNavigationBarItem(
      icon: Icon(Icons.settings_outlined), label: 'Settings'),
  const BottomNavigationBarItem(
      icon: Icon(Icons.admin_panel_settings_outlined), label: 'Admin'),
];


CupertinoAlertDialog _cupertinoAlertDialog(BuildContext context){
  return CupertinoAlertDialog(
    title: const Text('Create an account'),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateUser()));
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

AlertDialog _alertDialog(BuildContext context){
  return AlertDialog(
    title: const Text('Create an account'),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateUser()));
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