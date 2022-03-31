import 'dart:io';

import 'package:achieve/helper/database_service/user_service.dart';
import 'package:achieve/helper/helper.dart';
import 'package:achieve/user/LocalUser.dart';
import 'package:achieve/work_out.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'helper/database_service/database_ref.dart';
import 'home.dart';
import 'profile.dart';
import 'user/log_in.dart';
import 'work_plan.dart';

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
  File _img = File('assets/images/human.jpeg');

  void _checkUserStatus() async {
    final _auth = References.firebaseAuth;
    _auth.userChanges().listen((event) async {
      if (event == null) {
        _auth.signInAnonymously();
      } else {
        if (event.isAnonymous) {
          widget._isIOS
              ? showCupertinoDialog(
                  context: context,
                  builder: (context) => _cupertinoAlertDialog(context))
              : showDialog(
                  context: context,
                  builder: (context) => _alertDialog(context));
        } else {
          if (!event.emailVerified) {
            print('prompt to verify email');
          } else {
            print('update stuff');
          }
          _img = (await UserService.getProfileImage(event.uid))!;
        }
      }
    });
  }

  void _logInUser() async {
    LocalUser.signIn();
  }

  @override
  void initState() {
    _logInUser();
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
          const Home(),
          const Plan(),
          const WorkOut(),
          Profile(_img),
          //Admin
        ],
      ),
      bottomSheet: BottomNavigationBar(
        items: _bottomMenu(isManager),
        currentIndex: _selected,
        showSelectedLabels: true,
        selectedItemColor: Colors.greenAccent,
        onTap: onTapped,
      ),
    );
  }
}

List<BottomNavigationBarItem> _bottomMenu(bool _isManager) {
  List<BottomNavigationBarItem> _list = [];
  _list.add(const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined), label: 'Home'));
  _list.add(const BottomNavigationBarItem(
      icon: Icon(Icons.my_library_add_outlined), label: 'Courses'));
  _list.add(BottomNavigationBarItem(
      icon: Image.asset('assets/logo/IconOnly_Transparent_NoBuffer_20x16.png',
          fit: BoxFit.scaleDown, color: Colors.grey),
      activeIcon: Image.asset(
          'assets/logo/IconOnly_Transparent_NoBuffer_20x16.png',
          fit: BoxFit.scaleDown,
          color: Colors.grey),
      label: 'Own coach'));
  _list.add(const BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined), label: 'Settings'));

  if (_isManager) {
    _list.add(const BottomNavigationBarItem(
        icon: Icon(Icons.admin_panel_settings_outlined), label: 'Admin'));
  }
  return _list;
}

CupertinoAlertDialog _cupertinoAlertDialog(BuildContext context) {
  return CupertinoAlertDialog(
    title: const Text('Create an account'),
    actions: [
      TextButton(
          onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LogIn(true)));
            Navigator.pop(context);
          },
          child: const Text('Yes')),
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No')),
    ],
  );
}

AlertDialog _alertDialog(BuildContext context) {
  return AlertDialog(
    title: const Text('Create an account'),
    actions: [
      TextButton(
          onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LogIn(false)));
            Navigator.pop(context);
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
