import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:infinityhub/States/AuthenticateState.dart';

import 'package:infinityhub/UI/Home.dart';
import 'package:infinityhub/main.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    Key key,
    this.title,
  }) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  
  //UserCredential userverificationstatus;
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> registerUser(LoginData data) {
    String status;
    return Future.delayed(loginTime).then((_) async {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: data.name, password: data.password);
        return "Signed up!";
      } on FirebaseAuthException catch (e) {
        return e.message;
      }
    });
  }

  Future<String> signInUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      AuthenticationProvider(FirebaseAuth.instance)
          .signIn(email: data.name, password: data.password)
          .then((onError) {
        return onError.toString();
      });
      return;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
        onSignup: null,
        onLogin: signInUser,
        onRecoverPassword: null,
        logoTag: "IHlogo",
        onSubmitAnimationCompleted: () async {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MyHomePage1("IHlogo"),
          ));
        },
        messages: LoginMessages(
          usernameHint: 'Email',
          passwordHint: 'Password',
          confirmPasswordHint: 'Confirm Password',
          loginButton: 'LOG IN',
          signupButton: '',
          forgotPasswordButton: 'Forgot Password?',
          recoverPasswordButton: 'HELP ME',
          goBackButton: 'GO BACK',
          confirmPasswordError: 'Not match!',
          recoverPasswordDescription: 'Type your email',
          recoverPasswordSuccess: 'Password rescued successfully',
        ),
        logo: "assets/IHLogo.png",
        title: "",
        theme: LoginTheme(
            primaryColor: Colors.blue,
            accentColor: Colors.yellow,
            errorColor: Colors.red,
            cardTheme: CardTheme(
              color: Colors.yellow,
            ),
            inputTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(5),
              errorStyle: TextStyle(
                  backgroundColor: Colors.yellow,
                  color: Colors.black,
                  fontSize: 15),
            )));
  }
}
