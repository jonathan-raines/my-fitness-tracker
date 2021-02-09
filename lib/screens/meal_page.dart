import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_fitness_tracker/constants.dart';
import '../functions.dart';
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

  double totalCalories, totalProtein, totalCarbs, totalFats;

  Text caloriesByGramOrServing(dynamic food) {
    double protein, carbs, fats, calories;
    if (food['logByWeight']) {
      protein =
          ((food['nutriments']['proteins'] / 100) * food['loggedServings'])
              .roundToDouble();
      carbs =
          ((food['nutriments']['carbohydrates'] / 100) * food['loggedServings'])
              .roundToDouble();
      fats = ((food['nutriments']['fat'] / 100) * food['loggedServings'])
          .roundToDouble();
      calories = ((food['caloriesPerGram'] * food['loggedServings']) / 10)
              .roundToDouble() *
          10;
    } else {
      // food was logged by servings instead of my grams
      protein = (food['nutriments']['proteinsServing'] * food['loggedServings'])
          .roundToDouble();
      carbs =
          (food['nutriments']['carbohydratesServing'] * food['loggedServings'])
              .roundToDouble();
      fats = (food['nutriments']['fatServing'] * food['loggedServings'])
          .roundToDouble();
      calories = ((food['caloriesPerServing'] * food['loggedServings']) / 10)
              .roundToDouble() *
          10;
    }
    totalCalories += calories;
    totalProtein += protein;
    totalCarbs += carbs;
    totalFats += fats;

    return Text(
        'Calories: ${calories.round()}, Protein: ${protein.round()}, Carbs: ${carbs.round()}, Fat: ${fats.round()}');
  }

  Future<void> _foodEditMenu(QueryDocumentSnapshot meal, dynamic food) async {
    switch (await showDialog<FoodContextOptions>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('${meal.id}: ${food['productName']}'),
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
        Navigator.pushNamed(context, '/edit',
            arguments: productFromMap(food, food['nutriments']));
        /* Navigator.pushNamed(context, '/details',
            arguments: productFromMap(food, food['nutriments'])); */
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
      appBar: buildAppBar('Food Diary'),
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
                // TODO enable user to add food to selected meal id by clicking on heading
                mealWidgets.add(
                  Text(
                    '${meal.id}',
                    style: mealLabelsTextStyle,
                  ),
                );
                for (var food in meal.data()['foods']) {
                  mealWidgets.add(
                    ListTile(
                      title: Text(
                        '${food['productName']}',
                        style: foodLabelTextStyle,
                      ),
                      trailing: Text(
                        'Servings: ${food['loggedServings']}',
                        style: foodLabelTextStyle,
                      ),
                      subtitle: caloriesByGramOrServing(food),
                      onLongPress: () {
                        // TODO query document for this item and edit this one item
                        _foodEditMenu(meal, food);
                      },
                      onTap: () {
                        Navigator.pushNamed(context, '/details',
                            arguments:
                                productFromMap(food, food['nutriments']));
                      },
                    ),
                  );
                }
              }
              mealWidgets.add(ListTile(
                title: Text(
                  'Totals: ',
                  style: foodLabelTextStyle,
                ),
                subtitle: Text(
                  'Calories: ${totalCalories.round()}, Protein: ${totalProtein.round()}, Carbohydrates: ${totalCarbs.round()}, Fats: ${totalFats.round()}',
                  style: foodLabelTextStyle,
                ),
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
                onPressed: () {
                  getProductFromBarcode(context);
                },
                child: scanBarcodeButton,
              ),
            ],
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Text(
                'Settings',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 32,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                color: Colors.teal.shade600,
              ),
            ),
            ListTile(
              title: Text(
                'Sign out',
                style: TextStyle(fontFamily: 'Lato', fontSize: 21),
              ),
              trailing: Icon(Icons.logout),
              onTap: () {
                _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
            )
          ],
        ),
      ),
    );
  }
}
