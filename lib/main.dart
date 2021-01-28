import 'package:flutter/material.dart';
import 'package:my_fitness_tracker/product_details.dart';
import 'home_page.dart';
import 'search_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/search': (context) => SearchPage(),
        '/details': (context) => ProductDetails(),
      },
    );
  }
}
