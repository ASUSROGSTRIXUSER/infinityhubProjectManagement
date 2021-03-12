import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:infinityhub/States/AuthenticateState.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  //Controllers for e-mail and password textfields.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Handling signup and signin
  bool signUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(60, 50, 50, 30),
            child: Image.asset('assets/IHLogo.png'),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(150),
            child: SizedBox(
              width: 600.0,
              height: 300.0,
              child: Card(
                  color: Colors.yellow,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.blueAccent,
                                ),
                                border: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(90.0)),
                                    borderSide:
                                        BorderSide(color: Colors.white24)
                                    //borderSide: const BorderSide(),
                                    ),
                                hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "WorkSansLight"),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Email'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.blueAccent,
                                ),
                                border: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(90.0)),
                                    borderSide:
                                        BorderSide(color: Colors.white24)
                                    //borderSide: const BorderSide(),
                                    ),
                                hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "WorkSansLight"),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Password'),
                            obscureText: true,
                            controller: passwordController,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (signUp) {
                              //Provider sign up methodg
                              context
                                  .read<AuthenticationProvider>()
                                  .signUp(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  )
                                  .then((onError) {
                                Flushbar(
                                  title: "Hey!",
                                  message: onError.toString(),
                                  duration: Duration(seconds: 3),
                                )..show(context);
                              });
                            } else {
                              //Provider sign in method
                              context
                                  .read<AuthenticationProvider>()
                                  .signIn(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  )
                                  .then((onError) {
                                Flushbar(
                                  title: "Hey!",
                                  message: onError.toString(),
                                  duration: Duration(seconds: 3),
                                )..show(context);
                              });
                            }
                          },
                          child: signUp ? Text("Sign Up") : Text("Sign In"),
                        ),

                      /*  OutlinedButton(
                          onPressed: () {
                            setState(() {
                              signUp = !signUp;
                            });
                          },
                          child: signUp
                              ? Text("Have an account? Sign In")
                              : Text("Create an account"),
                        )*/

                      ],
                    ),
                  )),
            ),

            //password textfield

            //Sign in / Sign up button

            //Sign up / Sign In toggler
          )
        ],
      ),
    );
  }
}
