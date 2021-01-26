import 'package:flutter/material.dart';
import 'package:my_fitness_tracker/food_class.dart';
import 'package:my_fitness_tracker/services/open_food.dart';
import 'services/barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Meals extends StatefulWidget {
  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  final List<Food> foodList = [];
  List<Widget> children = [];
  int mealNumber = 1;
  String barcode;
  Product product;
  double totalCalories = 0;

  void buildWidget(String name, double protein, double carbs, double fats) {
    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Name: $name'),
        Text('Protein: $protein'),
        Text('Carbs: $carbs'),
        Text('Fats: $fats'),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: children,
        ),
        Divider(
          height: 15,
          thickness: 1,
          color: Colors.black,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Total Calories: $totalCalories'),
            TextButton(
              onPressed: () {},
              child: Icon(
                FontAwesomeIcons.plusCircle,
                color: Colors.blue,
                size: 30,
              ),
            ),
            TextButton(
              onPressed: () async {
                barcode = await scanBarcode();
                product = await getProduct(barcode);
                Food food = Food(product: product);
                foodList.add(food);
                totalCalories += food.calculateCalories().toDouble();
                setState(() {
                  buildWidget(
                      food.product.productName,
                      food.product.nutriments.proteinsServing,
                      food.product.nutriments.carbohydratesServing,
                      food.product.nutriments.fatServing);
                });
              },
              child: Icon(
                FontAwesomeIcons.barcode,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
