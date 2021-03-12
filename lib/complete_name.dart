import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infinityhub/UI/Home.dart';

class NameEntry extends StatefulWidget {
  @override
  _NameEntryState createState() => _NameEntryState();
}

class _NameEntryState extends State<NameEntry> {
  TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new TextField(
            controller: _controller,
            decoration: new InputDecoration(
              hintText: 'Type something',
            ),
          ),
          new ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.currentUser
                  .updateProfile(displayName: _controller.text);

              FirebaseAuth.instance.signOut();
            },
            child: new Text('DONE'),
          ),
        ],
      ),
    );
  }
}
