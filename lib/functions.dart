import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/Nutriments.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:openfoodfacts/model/parameter/SearchTerms.dart';
import 'package:openfoodfacts/model/parameter/TagFilter.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:my_fitness_tracker/constants.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';

Future<String> scanBarcode() async {
  String barcodeScanRes;

  try {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', false, ScanMode.BARCODE);
  } on PlatformException {
    barcodeScanRes = 'Failed to get platform version.';
  }
  return barcodeScanRes;
}

Future<Product> searchProductFromBarcode(String barcode) async {
  ProductQueryConfiguration configurations = ProductQueryConfiguration(barcode,
      language: OpenFoodFactsLanguage.ENGLISH, fields: productSearchFields);

  ProductResult result = await OpenFoodAPIClient.getProduct(configurations);

  if (result.status == 1 && result.product.productName != null) {
    return result.product;
  } else {
    return null;
  }
}

Future<dynamic> productSearchKeywords(List<String> keywords) async {
  var parameters = <Parameter>[
    SearchTerms(terms: keywords),
    const OutputFormat(format: Format.JSON),
    // const Page(page: 0),
    const PageSize(size: 25),
    const SearchSimple(active: true),
    const SortBy(option: SortOption.POPULARITY),
    const TagFilter(
        tagType: "countries", contains: true, tagName: "united states"),
  ];

  ProductSearchQueryConfiguration configuration =
      ProductSearchQueryConfiguration(
          parametersList: parameters,
          fields: productSearchFields,
          language: OpenFoodFactsLanguage.ENGLISH);

  SearchResult result =
      await OpenFoodAPIClient.searchProducts(null, configuration);

  return result;
}

Map<String, dynamic> productToMap(
        Product product, double servingSize, bool logByWeight) =>
    {
      'barcode': product.barcode ?? '',
      'productName': product.productName ?? '',
      'brands': product.brands ?? '',
      'nutriments': {
        'salt': (product.nutriments.salt ?? 0),
        'saltServing': (product.nutriments.saltServing ?? 0),
        'fiber': (product.nutriments.fiber ?? 0),
        'fiberServing': (product.nutriments.fiberServing ?? 0),
        'sugars': (product.nutriments.sugars ?? 0),
        'sugarsServing': (product.nutriments.sugarsServing ?? 0),
        'fat': (product.nutriments.fat ?? 0),
        'fatServing': (product.nutriments.fatServing ?? 0),
        'saturatedFat': (product.nutriments.saturatedFat ?? 0),
        'saturatedFatServing': (product.nutriments.saturatedFatServing ?? 0),
        'proteins': (product.nutriments.proteins ?? 0),
        'proteinsServing': (product.nutriments.proteinsServing ?? 0),
        'energyKcal100g': (product.nutriments.energyKcal100g ?? 0),
        'carbohydrates': (product.nutriments.carbohydrates ?? 0),
        'carbohydratesServing': (product.nutriments.carbohydratesServing ?? 0),
        'caffeine': (product.nutriments.caffeine ?? 0),
        'caffeineServing': (product.nutriments.caffeineServing ?? 0),
        'calcium': (product.nutriments.calcium ?? 0),
        'calciumServing': (product.nutriments.calciumServing ?? 0),
        'iron': (product.nutriments.iron ?? 0),
        'ironServing': (product.nutriments.ironServing ?? 0),
        'vitaminC': (product.nutriments.vitaminC ?? 0),
        'vitaminCServing': (product.nutriments.vitaminCServing ?? 0),
        'magnesium': (product.nutriments.magnesium ?? 0),
        'magnesiumServing': (product.nutriments.magnesiumServing ?? 0),
        'phosphorus': (product.nutriments.phosphorus ?? 0),
        'phosphorusServing': (product.nutriments.phosphorusServing ?? 0),
        'potassium': (product.nutriments.potassium ?? 0),
        'potassiumServing': (product.nutriments.potassiumServing ?? 0),
        'sodium': (product.nutriments.sodium ?? 0),
        'sodiumServing': (product.nutriments.sodiumServing ?? 0),
        'monounsaturatedAcid': (product.nutriments.monounsaturatedAcid ?? 0),
        'monounsaturatedServing':
            (product.nutriments.monounsaturatedServing ?? 0),
        'polyunsaturatedAcid': (product.nutriments.polyunsaturatedAcid ?? 0),
        'polyunsaturatedServing':
            (product.nutriments.polyunsaturatedServing ?? 0),
      },
      'servingSize': (product.servingSize ?? 0),
      'servingQuantity': (product.servingQuantity ?? 0),
      'caloriesPerServing': (((product.nutriments.proteinsServing * 4) +
                      (product.nutriments.carbohydratesServing * 4) +
                      (product.nutriments.fatServing * 9)) /
                  10.0)
              .round() *
          10,
      'caloriesPerGram': ((product.nutriments.energyKcal100g ?? 0) / 100),
      'logByWeight': logByWeight,
      'loggedServings': servingSize
    };

Product productFromMap(
        Map<String, dynamic> productMap, Map<String, dynamic> nutrimentMap) =>
    Product(
      barcode: productMap['barcode'],
      brands: productMap['brands'],
      productName: productMap['productName'],
      servingQuantity: productMap['servingQuantity'].toDouble(),
      servingSize: productMap['servingSize'],
      nutriments: nutrimentsFromMap(nutrimentMap),
    );

Nutriments nutrimentsFromMap(Map<String, dynamic> map) => Nutriments(
      salt: map['salt'],
      saltServing: map['saltServing'],
      fiber: map['fiber'],
      fiberServing: map['fiberServing'],
      sugars: map['sugars'],
      sugarsServing: map['sugarsServing'],
      fat: map['fat'],
      fatServing: map['fatServing'],
      saturatedFat: map['saturatedFat'],
      saturatedFatServing: map['saturatedFatServing'],
      proteins: map['proteins'],
      proteinsServing: map['proteinsServing'],
      energyKcal100g: map['energyKcal100g'],
      carbohydrates: map['carbohydrates'],
      carbohydratesServing: map['carbohydratesServing'],
      caffeine: map['caffeine'],
      caffeineServing: map['caffeineServing'],
      calcium: map['calcium'],
      calciumServing: map['calciumServing'],
      iron: map['iron'],
      ironServing: map['ironServing'],
      vitaminC: map['vitaminC'],
      vitaminCServing: map['vitaminCServing'],
      magnesium: map['magnesium'],
      magnesiumServing: map['magnesiumServing'],
      phosphorus: map['phosphorus'],
      phosphorusServing: map['phosphorusServing'],
      potassium: map['potassium'],
      potassiumServing: map['potassiumServing'],
      sodium: map['sodium'],
      sodiumServing: map['sodiumServing'],
      monounsaturatedAcid: map['monounsaturatedAcid'],
      monounsaturatedServing: map['monounsaturatedServing'],
      polyunsaturatedAcid: map['polyunsaturatedAcid'],
      polyunsaturatedServing: map['polyunsaturatedServing'],
    );

void getProductFromBarcode(BuildContext context) async {
  Product product = await searchProductFromBarcode(await scanBarcode());
  if (product != null) {
    Navigator.pushNamed(context, '/details', arguments: product);
  }
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('Food not found'),
        content: Text('Would you like to create a custom food?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/custom');
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}

AppBar buildAppBar(String title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontFamily: 'Lato', fontSize: 28),
    ),
    centerTitle: true,
    backgroundColor: Colors.teal.shade600,
  );
}
