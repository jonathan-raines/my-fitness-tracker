import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_fitness_tracker/functions.dart';

import '../constants.dart';
import '../components/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('Login'),
      body: Column(
        children: [
          SizedBox(
            height: 48,
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            decoration:
                textFieldDecoration.copyWith(hintText: 'Enter your email'),
            onChanged: (value) {
              email = value;
            },
          ),
          SizedBox(
            height: 16.0,
          ),
          TextField(
            obscureText: true,
            textAlign: TextAlign.center,
            decoration:
                textFieldDecoration.copyWith(hintText: 'Enter your password'),
            onChanged: (value) {
              password = value;
            },
          ),
          // TODO add password verification field
          RoundedButton(
            color: Colors.lightGreen,
            title: 'Login',
            onPressed: () async {
              try {
                UserCredential userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);

                if (userCredential != null) {
                  Navigator.pushReplacementNamed(context, '/diary');
                }
                // TODO implement verification email
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('The password provided is too weak.');
                } else if (e.code == 'email-already-in-use') {
                  print('The account already exists for that email.');
                }
              } catch (e) {
                print(e);
              }
            },
          )
          // TODO implement FORGOT PASSWORD
        ],
      ),
    );
  }
}
