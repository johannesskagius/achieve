import 'package:flutter/material.dart';

import 'helper/database_service/database_ref.dart';


class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.settings_outlined))
        ],
      ),
      body: Center(
        child: ElevatedButton(onPressed: () {
          References.firebaseAuth.signOut();
        }, child: const Text('Sign out'),
        ),
      ),
    );
  }
}
