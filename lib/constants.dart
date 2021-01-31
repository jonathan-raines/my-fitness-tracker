import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

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

buildWidget(Product product) {
  children.add(Row(
    children: [
      Expanded(
        child: Text(
          'Name: ${product.productName}',
        ),
      ),
      Expanded(
        child: Text(
          'Protein: ${product.nutriments.proteinsServing}',
        ),
      ),
      Expanded(
        child: Text(
          'Carbs: ${product.nutriments.carbohydratesServing}',
        ),
      ),
      Expanded(
        child: Text(
          'Fats: ${product.nutriments.fatServing}',
        ),
      ),
    ],
  ));
}

