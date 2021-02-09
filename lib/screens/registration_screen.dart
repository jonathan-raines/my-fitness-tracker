import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_fitness_tracker/components/rounded_button.dart';
import 'package:my_fitness_tracker/constants.dart';
import 'package:my_fitness_tracker/functions.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  String email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('Registration'),
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
          RoundedButton(
            color: Colors.lightGreen,
            title: 'Register',
            onPressed: () async {
              try {
                UserCredential userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);

                User user = FirebaseAuth.instance.currentUser;
                user.sendEmailVerification();

                if (userCredential != null && user.emailVerified) {
                  Navigator.pushNamed(context, '/diary');
                }
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
        ],
      ),
    );
  }
}
