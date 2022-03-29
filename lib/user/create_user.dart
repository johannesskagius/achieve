import 'package:achieve/helper/design_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/helper.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({Key? key}) : super(key: key);

  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final _pController = PageController();



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.unFocus,
      child: Scaffold(
        appBar: AppBar(title: DesignHelper.Header('Welcome to Our community')),
        body: Container(
          margin: DesignHelper.standardInsets(),
          child: PageView(
            pageSnapping: true,
            controller: _pController,
            children: const [
              LogIn(),
            ],
          ),
        ),
      ),
    );
  }
}

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _list =
      List.generate(3, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Theme.of(context).platform == TargetPlatform.iOS
            ? _cuperTinoForm(_formKey, _list)
            : _notIosForm(_formKey, _list),
      ],
    );
  }
}

CupertinoFormSection _cuperTinoForm(
    GlobalKey<FormState> _key, List<TextEditingController> _list) {
  return CupertinoFormSection
      .insetGrouped(key: _key, backgroundColor: Colors.transparent, children: [
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CupertinoTextFormFieldRow(
          prefix: const Text(
            'Email: ',
            style: TextStyle(color: Colors.white38),
          ),
          validator: (value) {
            if (value == null || value.length < 3) {
              return 'value has to be longer than 3 characters';
            }
            return null;
          },
          controller: _list.elementAt(0),
          keyboardType: TextInputType.emailAddress,
        ),
        CupertinoTextFormFieldRow(
          prefix: const Text(
            'Password: ',
            style: TextStyle(color: Colors.white38),
          ),
          validator: (value) {
            if (value == null || value.length < 3) {
              return 'value has to be longer than 3 characters';
            }
            return null;
          },
          controller: _list.elementAt(1),
          keyboardType: TextInputType.visiblePassword,
        ),
        DesignHelper.dividerStd(),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: CupertinoButton(child: const Text('Log in'), onPressed: () {}),
        ),
        DesignHelper.dividerStd(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CupertinoButton(child: const Text(''), onPressed: () {

            }),
            CupertinoButton(child: const Text('F'), onPressed: () {

            }),
            CupertinoButton(child: const Text('G'), onPressed: () {

            }),
          ],
        ),
        DesignHelper.dividerStd(),
        TextButton(
          onPressed: () {

          },
          child: const Text('Dont have an account'),
          style: TextButton.styleFrom(
              primary: Colors.white38, textStyle: const TextStyle(fontSize: 10)),
        )
      ],
    ),
  ]);
}

Form _notIosForm(GlobalKey<FormState> _key, List<TextEditingController> _list) {
  return Form(
    key: _key,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextFormField(
          controller: _list.elementAt(0),
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'email',
          ),
          validator: (value) {
            if (value == null || value.length < 3) {
              return 'value has to be longer than 3 characters';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _list.elementAt(1),
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            hintText: 'Password',
          ),
          validator: (value) {
            if (value == null || value.length < 3) {
              return 'value has to be longer than 3 characters';
            }
            return null;
          },
        ),
      ],
    ),
  );
}
