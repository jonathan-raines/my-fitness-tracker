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
      .collection('meals');

  int totalCalories = 0, totalProtein = 0, totalCarbs = 0, totalFats = 0;

  int calculateCalories() =>
      (totalProtein.round() * 4) +
      (totalCarbs.round() * 4) +
      (totalFats.round() * 9);

  @override
  Widget build(BuildContext context) {
    calculateCalories();
    return Scaffold(
      appBar: AppBar(
        title: Text('My Diary'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: docRef.snapshots(),
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
                mealWidgets.add(Text('Meal ${meal.id}'));
                for (var food in meal.data()['foods']) {
                  mealWidgets.add(ListTile(
                    title: Text('${food['productName']}'),
                    subtitle: Text(
                      'Protein: ${food['nutriments']['proteinsServing'].toInt()} Carbohydrates: ${food['nutriments']['carbohydratesServing'].toInt()} Fats: ${food['nutriments']['fatServing'].toInt()}',
                      textAlign: TextAlign.start,
                    ),
                    onLongPress: () {
                      docRef.doc(meal.id).update({
                        'foods': FieldValue.arrayRemove([food])
                      });
                    },
                  ));
                  totalProtein += food['nutriments']['proteinsServing'].round();
                  totalCarbs +=
                      food['nutriments']['carbohydratesServing'].round();
                  totalFats += food['nutriments']['fatServing'].round();
                }
              }
              totalCalories = calculateCalories();
              mealWidgets.add(ListTile(
                title: Text('Totals: '),
                subtitle: Text(
                    'Calories: $totalCalories, Protein: $totalProtein, Carbohydrates: $totalCarbs, Fats: $totalFats'),
              ));
              return Column(
                children: mealWidgets,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () async {
                  Navigator.pushNamed(context, '/search');
                },
                child: addFoodButton,
              ),
              TextButton(
                onPressed: () async {
                  Product product = await getProduct(await scanBarcode());

                  Navigator.pushNamed(context, '/details', arguments: product);
                },
                child: scanBarcodeButton,
              ),
            ],
          )
        ],
      ),
    );
  }
}
