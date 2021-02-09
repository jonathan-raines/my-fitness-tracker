import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_fitness_tracker/components/rounded_button.dart';
import 'package:my_fitness_tracker/constants.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  String email, password, verifyPassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
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
          SizedBox(
            height: 16.0,
          ),
          TextField(
            obscureText: true,
            textAlign: TextAlign.center,
            decoration:
                textFieldDecoration.copyWith(hintText: 'Verify your password'),
            onChanged: (value) {
              verifyPassword = value;
            },
          ),
          RoundedButton(
            color: Colors.lightGreen,
            title: 'Register',
            onPressed: () async {
              if (password == verifyPassword) {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);

                  if (userCredential != null) {
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
              }
              return AlertDialog(
                title: Text('Passwords do not match'),
              );
            },
          )
        ],
      ),
    );
  }
}
