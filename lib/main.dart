import 'package:firebase_auth/firebase_auth.dart';
import 'package:infinityhub/UI/Home.dart';
import 'package:infinityhub/UI/login.dart';
import 'package:infinityhub/UI/login.dart';
import 'package:infinityhub/complete_name.dart';
import 'States/AuthenticateState.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'States/ThemeState.dart';
import 'UI/loginv2.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider<ThemeState>(
      create: (context) => ThemeState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
        )
      ],
      child: MaterialApp(
        title: 'IH Staff',
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeState>(context).theme == ThemeType.DARK
            ? ThemeData.dark()
            : ThemeData.light(),
        home: Authenticate(),
      ),
    );
  }
}

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      if (firebaseUser.displayName == null) {
        return NameEntry();
      } else {
        return MyHomePage1('ihlogo');
      }
    }
    return LogInPage(); //  LogInPage();
  }
}
