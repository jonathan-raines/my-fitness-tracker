import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fitness_tracker/classes/food_product.dart';
import 'package:my_fitness_tracker/constants.dart';
import 'package:my_fitness_tracker/services/open_food.dart';
import '../services/barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import '../services.dart';
import '../constants.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
                  Product product = await getProduct(await scanBarcode());

                  FoodProduct foodProduct = FoodProduct(
                      name: product.productName,
                      calories: product.nutriments.energyServing,
                      totalFat: product.nutriments.fatServing,
                      saturatedFat: product.nutriments.saturatedFatServing,
                      transFat: 0,
                      polyUnsaturatedFat:
                          product.nutriments.polyunsaturatedServing,
                      monoUnsaturatedFat:
                          product.nutriments.monounsaturatedServing,
                      cholestrol: product.nutriments.cholesterolServing,
                      sodium: product.nutriments.sodiumServing,
                      totalCarbohydrates:
                          product.nutriments.carbohydratesServing,
                      dietaryFiber: product.nutriments.fiberServing,
                      totalSugars: product.nutriments.sugarsServing,
                      protein: product.nutriments.proteinsServing,
                      vitaminD: product.nutriments.vitaminD,
                      iron: product.nutriments.ironServing,
                      calcium: product.nutriments.calciumServing,
                      potassium: product.nutriments.potassiumServing);

                  _firestore
                      .collection('users')
                      .doc('8VycZkCjsrK9SsnaTK4U')
                      .collection('date')
                      .doc('2020-02-02')
                      .collection('meals')
                      .doc('meal1')
                      .update({
                    'foods': FieldValue.arrayUnion([foodProduct.toMap()])
                  });
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
