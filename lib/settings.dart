import 'package:achieve/helper/design_helper.dart';
import 'package:achieve/user/LocalUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings(this._ios, {Key? key}) : super(key: key);
  final bool _ios;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text('Account', style: DesignHelper.barelyVisible(),),
              const Divider(),
              _getCard('Membership'),
              _getCard('Applications'),
              _getCard('Membership terms'),
              _getCard('Notifications'),
              const Divider(),
              Text('Preferences', style: DesignHelper.barelyVisible(),),
              _getCard('Pricacy'),
              _getCard('Units'),
              _getCard('Temperature'),
              _getCard('Beacon'),
              _getCard('DataPermissions'),
              _getCard('DataPermissions'),
              _getCard('Contacts'),
              _getCard('Help'),
              const Divider(),
              _ios ? CupertinoButton.filled(child: const Text('Sign out'), onPressed: (){
                LocalUser.signOut();
              }) : TextButton(onPressed: (){
                LocalUser.signOut();
              }, child: const Text('Sign out'))
            ],
          ),
        ),
      ),
    );
  }
}

Padding _getCard(String _title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1.0),
    child: GestureDetector(
      child: Card(
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(_title),
              const Icon(Icons.navigate_next),
            ],
          ),
        ),
      ),
    ),
  );
}
