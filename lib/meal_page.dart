import 'package:flutter/material.dart';
import 'package:my_fitness_tracker/constants.dart';
import 'package:my_fitness_tracker/services/open_food.dart';
import 'services/barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class Meals extends StatefulWidget {
  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  final List<Product> foodList = [];
  final List<Widget> children = [];
  double totalCalories = 0, totalProtein = 0, totalCarbs = 0, totalFats = 0;

  void buildWidget(String name, double protein, double carbs, double fats) {
    children.add(Row(
      children: [
        Expanded(
          child: Text(
            'Name: $name',
            overflow: TextOverflow.clip,
          ),
        ),
        Expanded(
          child: Text(
            'Protein: $protein',
            overflow: TextOverflow.clip,
          ),
        ),
        Expanded(
          child: Text(
            'Carbs: $carbs',
            overflow: TextOverflow.clip,
          ),
        ),
        Expanded(
          child: Text(
            'Fats: $fats',
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    ));
  }

  double calculateCalories(Product product) {
    return (product.nutriments.proteinsServing * 4) +
        (product.nutriments.fatServing * 9) +
        (product.nutriments.carbohydratesServing * 4);
  }

  void calculateTotals(Product product) {
    totalCalories += calculateCalories(product).toDouble();
    totalProtein += product.nutriments.proteinsServing;
    totalCarbs += product.nutriments.carbohydratesServing;
    totalFats += product.nutriments.fatServing;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: children,
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
                Product product;
                product = await getProduct(await scanBarcode());
                foodList.add(product);
                calculateTotals(product);

                setState(() {
                  buildWidget(
                      product.productName,
                      product.nutriments.proteinsServing,
                      product.nutriments.carbohydratesServing,
                      product.nutriments.fatServing);
                });
              },
              child: scanBarcodeButton,
            ),
          ],
        ),
      ],
    );
  }
}
