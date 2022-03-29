import 'dart:io';

import 'package:achieve/helper/design_helper.dart';
import 'package:achieve/user/LocalUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../helper/database_service/database_ref.dart';
import '../helper/helper.dart';

class LogIn extends StatefulWidget {
  const LogIn(this._ios, {Key? key}) : super(key: key);
  final bool _ios;

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  String _asset = 'assets/human.jpeg';
  XFile? _photo;
  File? _photo2;
  final List<TextEditingController> _list =
      List.generate(3, (index) => TextEditingController());
  bool _create = false;

  CupertinoFormSection _cuperTinoForm(BuildContext context) {
    return CupertinoFormSection.insetGrouped(
        key: _formKey,
        backgroundColor: Colors.transparent,
        children: [
          Container(
            child: Scrollbar(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _create
                          ? GestureDetector(
                              onTap: () async {
                                _photo = await Helper.showChoiceDialog(context);
                                setState(() {
                                  _photo2 = File(_photo!.path);
                                });
                              },
                              child: _photo2 != null
                                  ? Image.file(_photo2!)
                                  : Image.asset('assets/images/human.jpeg'))
                          : const SizedBox.shrink(),
                      DesignHelper.dividerStd(),
                      CupertinoTextFormFieldRow(
                        prefix: const Text(
                          'Email: ',
                          style: TextStyle(color: Colors.white38),
                        ),
                        validator: (value) {
                          if (value == null || value.length > 3) {
                            return 'value has to be longer than 3 characters';
                          }
                          return null;
                        },
                        controller: _list.elementAt(0),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      CupertinoTextFormFieldRow(
                        prefix: const Text(
                          'Password:  ',
                          style: TextStyle(color: Colors.white38),
                        ),
                        validator: (value) {
                          if (value == null || value.length > 3) {
                            return 'value has to be longer than 3 characters';
                          }
                          return null;
                        },
                        controller: _list.elementAt(1),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      DesignHelper.dividerStd(),
                      _create
                          ? DesignHelper.dividerStd()
                          : const SizedBox.shrink(),
                      _create
                          ? CupertinoTextFormFieldRow(
                              prefix: const Text(
                                'Name:  ',
                                style: TextStyle(color: Colors.white38),
                              ),
                              validator: (value) {
                                if (value == null || value.length > 3) {
                                  return 'value has to be longer than 3 characters';
                                }
                                return null;
                              },
                              controller: _list.elementAt(2),
                              keyboardType: TextInputType.visiblePassword,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          : const SizedBox.shrink(),
                      _create
                          ? DesignHelper.dividerStd()
                          : const SizedBox.shrink(),
                      _create
                          ? DesignHelper.dividerStd()
                          : const SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: _create
                            ? CupertinoButton(
                                child: const Text('Create user'),
                                onPressed: () async {
                                    String _email =
                                        _list.elementAt(0).value.text;
                                    String _password =
                                        _list.elementAt(1).value.text;
                                    String _pName =
                                        _list.elementAt(2).value.text;
                                    try {
                                      UserCredential _userCred =
                                          await References.firebaseAuth
                                              .createUserWithEmailAndPassword(
                                                  email: _email,
                                                  password: _password);

                                      if (_userCred.user != null) {
                                        final _user = _userCred.user;
                                        _user!.updateDisplayName(_pName);
                                        _user.sendEmailVerification();
                                        References.firebaseAuth
                                            .signInWithEmailAndPassword(
                                                email: _email,
                                                password: _password);
                                        LocalUser _local = LocalUser(_user.uid,
                                            _user.email, _password, _pName);
                                        _local.saveUser();
                                        Navigator.pop(context);
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      print(e.message);
                                    }
                                })
                            : CupertinoButton(
                                child: const Text('Log in'), onPressed: () async {
                          String _email =
                              _list.elementAt(0).value.text;
                          String _password =
                              _list.elementAt(1).value.text;
                          try {
                            UserCredential _user = await References.firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password);
                            LocalUser _local = LocalUser(_user.user!.uid, _email, _email, _password);
                            _local.saveUser();
                          }on FirebaseAuthException catch (e) {
                            print(e.message);
                          }
                          Navigator.pop(context);
                        }),
                      ),
                      DesignHelper.dividerStd(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CupertinoButton(
                              child: const Text(''), onPressed: () {}),
                          CupertinoButton(
                              child: const Text('F'), onPressed: () {}),
                          CupertinoButton(
                              child: const Text('G'), onPressed: () {}),
                        ],
                      ),
                      DesignHelper.dividerStd(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if (_create) {
                              _create = false;
                            } else {
                              _create = true;
                            }
                          });
                        },
                        child: _create
                            ? const Text('Sign in')
                            : const Text('Create account'),
                        style: TextButton.styleFrom(
                            primary: Colors.white38,
                            textStyle: const TextStyle(fontSize: 10)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]);
  }

  Form _notIosForm(BuildContext _context) {
    return Form(
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
          DesignHelper.dividerStd(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: _create
                ? TextButton(child: const Text('Log in'), onPressed: () {})
                : TextButton(
                    child: const Text('Create user'), onPressed: () {}),
          ),
          DesignHelper.dividerStd(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(child: const Text(''), onPressed: () {}),
              TextButton(child: const Text('F'), onPressed: () {}),
              TextButton(child: const Text('G'), onPressed: () {}),
            ],
          ),
          DesignHelper.dividerStd(),
          TextButton(
              onPressed: () {
                setState(() {
                  if (_create) {
                    _create = false;
                  } else {
                    _create = true;
                  }
                });
              },
              child: _create
                  ? const Text('Have an account, sign in')
                  : const Text('Dont have an account'),
              style: TextButton.styleFrom(
                primary: Colors.white38,
                textStyle: DesignHelper.buttonStandard(),
              ))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.unFocus,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: DesignHelper.Header('Welcome to Our community')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget._ios ? _cuperTinoForm(context) : _notIosForm(context),
          ],
        ),
      ),
    );
  }
}
