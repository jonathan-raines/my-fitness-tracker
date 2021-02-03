import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fitness_tracker/constants.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import '../services.dart';
import '../constants.dart';

//final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Meals extends StatefulWidget {
  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  double totalCalories = 0, totalProtein = 0, totalCarbs = 0, totalFats = 0;

  double calculateCalories(Product product) {
    return (product.nutriments.proteinsServing * 4) +
        (product.nutriments.fatServing * 9) +
        (product.nutriments.carbohydratesServing * 4);
  }

  void calculateTotals(List<Product> foodList) {
    totalCalories = totalProtein = totalCarbs = totalFats = 0;
    for (Product product in foodList) {
      totalCalories += calculateCalories(product).toDouble();
      totalProtein += product.nutriments.proteinsServing;
      totalCarbs += product.nutriments.carbohydratesServing;
      totalFats += product.nutriments.fatServing;
    }
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
          Column(
            children: [],
          ),
          mealDivider,
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
                  Product product =
                      await getProduct('038000138416'); //await scanBarcode());

                  Navigator.pushNamed(context, '/details', arguments: product);
                },
                child: scanBarcodeButton,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
