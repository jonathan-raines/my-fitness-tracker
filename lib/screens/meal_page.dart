import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_fitness_tracker/constants.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import '../services.dart';
import '../constants.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
var formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

class Meals extends StatefulWidget {
  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  var docRef = _firestore
      .collection('users')
      .doc(_auth.currentUser.uid)
      .collection('date')
      .doc(formattedDate)
      .collection('meals')
      .snapshots();
  // .doc(1.toString());

  double totalCalories = 0, totalProtein = 0, totalCarbs = 0, totalFats = 0;

  void calculateCalories() {
    totalCalories = (totalProtein * 4) + (totalCarbs * 4) + (totalFats * 9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Diary'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: docRef,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              final meals = snapshot.data.docs;

              List<Widget> mealWidgets = [];
              totalCalories = 0;
              totalProtein = 0;
              totalCarbs = 0;
              totalFats = 0;

              for (var meal in meals) {
                for (var food in meal.data()['foods']) {
                  mealWidgets.add(Text('${food['productName']}'));
                  totalProtein += food['nutriments']['proteinsServing'];
                  totalCarbs += food['nutriments']['carbohydratesServing'];
                  totalFats += food['nutriments']['fatServing'];
                }
              }
              mealWidgets.add(mealDivider);

              calculateCalories();

              mealWidgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Calories: $totalCalories'),
                        Text('Total Protein: $totalProtein'),
                        Text('Total Carbs: $totalCarbs'),
                        Text('Total Fats: $totalFats'),
                      ],
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pushNamed(context, '/search');
                      },
                      child: addFoodButton,
                    ),
                    TextButton(
                      onPressed: () async {
                        Product product = await getProduct(await scanBarcode());

                        Navigator.pushNamed(context, '/details',
                            arguments: product);
                      },
                      child: scanBarcodeButton,
                    ),
                  ],
                ),
              );
              return Column(
                children: mealWidgets,
              );
            },
          ),
        ],
      ),
    );
  }
}
