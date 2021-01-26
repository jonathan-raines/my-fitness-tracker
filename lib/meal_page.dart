import 'package:flutter/material.dart';
import 'food_macros.dart';
import 'services/open_food.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'services/barcode_scanner.dart';
import 'package:http/http.dart' as http;

class Meals extends StatefulWidget {
  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  int mealNumber = 1;
  Product product;
  List<Food> foodList = [];
  Food food = Food();
  String barcodeRes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(food.productName ?? '0'),
            Text(food.servingSize ?? '0'),
            Text(food.calories.toString() ?? '0'),
            Text(food.protein.toString() ?? '0'),
            Text(food.carbs.toString() ?? '0'),
          ],
        ),
        Column(
          children: [
            FlatButton(
              onPressed: () async {
                barcodeRes = await scanBarcode();
                print(barcodeRes);
                product = await getProduct(barcodeRes);

                setState(() {
                  food = Food(
                    productName: product.productName,
                    calories: product.nutriments.energy,
                    carbs: product.nutriments.carbohydrates,
                    protein: product.nutriments.proteins,
                    fat: product.nutriments.fat,
                    servingSize: product.servingSize,
                  );
                  foodList.add(food);
                });
              }, // scanBarcode(),
              child: Text('Scan Barcode'),
            ),
          ],
        )
      ],
    );
  }
}
