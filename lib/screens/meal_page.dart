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

  @override
  void initState() {
    super.initState();
    // Create Empty Meal Documents inside the Date collection
    for (var i = 1; i <= numberOfMeals; i++) {
      docRef.doc('Meal $i').get().then((doc) => {
            !doc.exists
                ? docRef.doc('Meal $i').set({'foods': []})
                : docRef
                    .doc('Meal $i')
                    .update({'foods': FieldValue.arrayUnion([])})
          });
    }
  }

  int totalCalories = 0;
  double totalProtein = 0, totalCarbs = 0, totalFats = 0;

  Future<void> _askedToLead(QueryDocumentSnapshot meal, dynamic food) async {
    switch (await showDialog<FoodContextOptions>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            //title: const Text('Select assignment'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, FoodContextOptions.edit);
                },
                child: const Text('Edit'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, FoodContextOptions.delete);
                },
                child: const Text('Delete'),
              ),
            ],
          );
        })) {
      case FoodContextOptions.edit:
        Navigator.pushNamed(context, '/details',
            arguments: fromMap(food, food['nutriments']));
        break;
      case FoodContextOptions.delete:
        docRef.doc(meal.id).update({
          'foods': FieldValue.arrayRemove([food])
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Diary'),
        centerTitle: true,
        backgroundColor: Colors.teal.shade600,
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
                mealWidgets.add(Text('${meal.id}'));
                for (var food in meal.data()['foods']) {
                  mealWidgets.add(ListTile(
                    title: Text('${food['productName']}'),
                    trailing: Text('Servings: ${food['servings']}'),
                    subtitle: Text(
                      'Protein: ${(food['nutriments']['proteinsServing'] * food['servings']).round()} Carbohydrates: ${(food['nutriments']['carbohydratesServing'] * food['servings']).round()} Fats: ${(food['nutriments']['fatServing'] * food['servings']).round()}',
                      textAlign: TextAlign.start,
                    ),
                    onLongPress: () {
                      _askedToLead(meal, food);
                      /*  */
                    },
                    onTap: () {
                      Navigator.pushNamed(context, '/details',
                          arguments: fromMap(food, food['nutriments']));
                    },
                  ));
                  totalProtein +=
                      food['nutriments']['proteinsServing'] * food['servings'];
                  totalCarbs += food['nutriments']['carbohydratesServing'] *
                      food['servings'];
                  totalFats +=
                      food['nutriments']['fatServing'] * food['servings'];
                  totalCalories += food['calories'] * food['servings'];
                }
              }
              mealWidgets.add(ListTile(
                title: Text('Totals: '),
                subtitle: Text(
                    'Calories: $totalCalories, Protein: ${totalProtein.round()}, Carbohydrates: ${totalCarbs.round()}, Fats: ${totalFats.round()}'),
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
          ),
          TextButton(
            child: Text('Sign out'),
            onPressed: () {
              _auth.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          )
        ],
      ),
    );
  }
}
