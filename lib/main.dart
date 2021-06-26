import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/home_page.dart';
import 'screens/login_screen.dart';
import 'screens/meal_page.dart';
import 'screens/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(NutritiOWN());
}

class NutritiOWN extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: FirebaseAuth.instance.currentUser != null ? '/diary' : '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/diary': (context) => Meals(),
        /* '/search': (context) => SearchPage(), */
        /* '/details': (context) => ProductDetails(), */
        /* '/custom': (context) => CustomProductForm(), */
      },
    );
  }
}
