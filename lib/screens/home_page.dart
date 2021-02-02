import 'package:flutter/material.dart';
import '../components/rounded_button.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutriti-OWN'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          RoundedButton(
            color: Colors.lightBlue,
            title: 'Log In',
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          RoundedButton(
            color: Colors.lightBlue,
            title: 'Register',
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
          ),
        ],
      ),
    );
  }
}
