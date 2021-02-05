import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/utils/ProductFields.dart';

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

const textFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const productSearchFields = [
  ProductField.BRANDS,
  ProductField.NAME,
  ProductField.SERVING_SIZE,
  ProductField.NUTRIMENTS,
];

const int numberOfMeals = 5;

enum FoodContextOptions { edit, delete }
