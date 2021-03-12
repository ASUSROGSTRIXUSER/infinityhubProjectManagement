import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/src/models/login_data.dart';

class AuthenticationProvider {
  final FirebaseAuth firebaseAuth;

  AuthenticationProvider(this.firebaseAuth);

  Stream<User> get authState => firebaseAuth.idTokenChanges();

  Future<String> signUp({String email, String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

         
      return "Signed up!";
    } on FirebaseAuthException catch (e) {
      print( e.message);
      return e.message;
    }
  }
  
  //SIGN IN METHOD
  Future<String> signIn({String email, String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in!";
    } on FirebaseAuthException catch (e) {
      
      return e.message;
    }
  }
}
