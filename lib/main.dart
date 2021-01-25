import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Meals(),
    );
  }
}

class Meals extends StatefulWidget {
  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  int mealNumber = 1;
  Future<Product> product;

  Future<void> scanBarcode() async {
    // ignore: unused_local_variable
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', false, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  /// request a product from the OpenFoodFacts database
  Future<Product> getProduct(String barcode) async {
    ProductQueryConfiguration configuration = ProductQueryConfiguration(barcode,
        language: OpenFoodFactsLanguage.GERMAN, fields: [ProductField.ALL]);
    ProductResult result = await OpenFoodAPIClient.getProduct(configuration);

    if (result.status == 1) {
      print(result.product.productName);
      return result.product;
    } else {
      throw new Exception(
          "product not found, please insert data for " + barcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Meal $mealNumber')],
            ),
          ],
        ),
        Column(
          children: [
            FlatButton(
              onPressed: () {
                product = getProduct('0048151623426');
              }, // scanBarcode(),
              child: Text('Scan Barcode'),
            ),
          ],
        )
      ],
    );
  }
}
