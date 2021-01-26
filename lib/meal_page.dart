import 'package:flutter/material.dart';
import 'package:my_fitness_tracker/services/open_food.dart';
import 'services/barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class Meals extends StatefulWidget {
  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  final List<Product> foodList = [];
  String barcode;
  Product product;

  Widget updateUI() {
    return Text('No FOOD Selected');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [updateUI()],
        ),
        Column(
          children: [
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () async {
                barcode = await scanBarcode();
                product = await getProduct(barcode);
                foodList.add(product);
              }, // scanBarcode(),
              child: Text('Scan Barcode'),
            ),
          ],
        )
      ],
    );
  }
}
