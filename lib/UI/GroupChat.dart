import 'dart:async';
import 'dart:html';
import 'dart:js';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:infinityhub/States/ThemeState.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewHomePage extends StatefulWidget {
  NewHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<NewHomePage> {
  var datetoday;
  ScrollController _controller = ScrollController();
  TextEditingController chatcontent = new TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      // extendBodyBehindAppBar: true,

      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 60),
            child: chatbuilder(),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              //color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        // color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: chatcontent,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          //   hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      sendmessage();
                      chatcontent.clear();
                    },

                    child: Icon(
                      Icons.send,
                      size: 18,
                    ),
                    // backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget chatbuilder() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('GlobalChat')
          .orderBy("fulldatetimesent", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.data);
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return new ListView(
          reverse: true,
          controller: _controller,
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            //      print(       document.data().entries.first.value['sender']);
            return bubbleChat(
                document.data()['message'],
                document.data()['sender'],
                document.data()['timesent_view'],
                document.data()['fulldatetimesent']
                //  document.data().entries.length-1,

                //subtitle: new Text(document.data()['company']),
                );
          }).toList(),
        );
      },
    );
  }

  Widget bubbleChat(var messagetext, var sender, var timesent, var timestamp) {
    var toDate = DateFormat.yMMMd().add_jm().format(timestamp.toDate());
    return sender == FirebaseAuth.instance.currentUser.displayName
        ? Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                alignment: Alignment.centerRight,
                child: Text(
                  "$sender , $toDate",
                  style: TextStyle(fontSize: 12),
                ),
              ),
              new BubbleNormal(
                text: messagetext,
                isSender: true,
                color: Color(0xAF6AD0F5),
                sent: true,
              ),
            ],
          )
        : Column(children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                "$sender ,$toDate",
                style: TextStyle(fontSize: 12),
              ),
            ),
            new BubbleNormal(
              text: messagetext,
              isSender: false,
              color: Color(0xAF6AD0F5),
              tail: true,
              seen: true,
              sent: true,
            ),
          ]);
  }

  Future<void> sendmessage() {
    // Call the user's CollectionReference to add a new user
    return FirebaseFirestore.instance
        .collection('GlobalChat')
        .add({
          'message': chatcontent.text,
          'fulldatetimesent': FieldValue.serverTimestamp(),
          'timesent_view': DateFormat.jm().format(DateTime.now()).toString(),
          'datesent_view':
              DateFormat.yMd('en_US').format(DateTime.now()).toString(),
          'sender': FirebaseAuth.instance.currentUser.displayName,
        })
        .then((value) => Timer(Duration(milliseconds: 500),
            () => _controller.jumpTo(_controller.position.minScrollExtent)))
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((error) => print("Send Failed : $error"));
  }
}
