import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/Product.dart';

const addFoodButton = Icon(
  FontAwesomeIcons.plusCircle,
  color: Colors.blue,
  size: 30,
);

const mealDivider = Divider(
  color: Colors.black,
  thickness: 2,
);

const scanBarcodeButton = Icon(
  FontAwesomeIcons.barcode,
  color: Colors.blue,
  size: 30,
);

final List<Product> foodList = [];
final List<Widget> children = [];

buildWidget(String name, double protein, double carbs, double fats) {
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
