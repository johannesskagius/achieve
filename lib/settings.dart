import 'package:achieve/helper/database_service/database_ref.dart';
import 'package:achieve/helper/design_helper.dart';
import 'package:achieve/user/LocalUser.dart';
import 'package:achieve/user/log_in.dart';
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
      body: References.firebaseAuth.currentUser == null ||
              References.firebaseAuth.currentUser!.isAnonymous
          ? LogIn(_ios)
          : Container(
              child: SingleChildScrollView(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      'Account',
                      style: DesignHelper.barelyVisible(),
                    ),
                    const Divider(),
                    _getCard('Membership'), //todo Implement
                    _getCard('Applications'), //todo Implement
                    _getCard('Membership terms'), //todo Implement
                    _getCard('Notifications'), //todo Implement
                    const Divider(),
                    Text('Preferences', style: DesignHelper.barelyVisible()),
                    _getCard('Pricacy'), //todo Implement
                    _getCard('Units'), //todo Implement
                    _getCard('Temperature'), //todo Implement
                    _getCard('Beacon'), //todo Implement
                    _getCard('DataPermissions'), //todo Implement
                    _getCard('DataPermissions'), //todo Implement
                    _getCard('Contacts'), //todo Implement
                    _getCard('Help'), //todo Implement
                    const Divider(),
                    _ios
                        ? CupertinoButton.filled(
                            child: const Text('Sign out'),
                            onPressed: () {
                              LocalUser.signOut();
                            })
                        : TextButton(
                            onPressed: () {
                              LocalUser.signOut();
                            },
                            child: const Text('Sign out'))
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
