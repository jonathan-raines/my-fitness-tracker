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

Future<Product> getProduct(String barcode) async {
  ProductQueryConfiguration configurations = ProductQueryConfiguration(barcode,
      language: OpenFoodFactsLanguage.ENGLISH, fields: productSearchFields);

  ProductResult result = await OpenFoodAPIClient.getProduct(configurations);

  if (result.status == 1) {
    return result.product;
  } else {
    throw new Exception("product not found, please insert data for " + barcode);
  }
}

Future<dynamic> productSearchKeywords(List<String> keywords) async {
  var parameters = <Parameter>[
    SearchTerms(terms: keywords),
    const OutputFormat(format: Format.JSON),
    const Page(page: 0),
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

Map<String, dynamic> toMap(Product product) => {
      'barcode': product.barcode,
      'productName': product.productName,
      'brands': product.brands,
      'nutriments': {
        'salt': product.nutriments.salt,
        'saltServing': product.nutriments.saltServing,
        'fiber': product.nutriments.fiber,
        'fiberServing': product.nutriments.fiberServing,
        'sugars': product.nutriments.sugars,
        'sugarsServing': product.nutriments.sugarsServing,
        'fat': product.nutriments.fat,
        'fatServing': product.nutriments.fatServing,
        'saturatedFat': product.nutriments.saturatedFat,
        'saturatedFatServing': product.nutriments.saturatedFatServing,
        'proteins': product.nutriments.proteins,
        'proteinsServing': product.nutriments.proteinsServing,
        'energyKcal100g': product.nutriments.energyKcal100g,
        'carbohydrates': product.nutriments.carbohydrates,
        'carbohydratesServing': product.nutriments.carbohydratesServing,
        'caffeine': product.nutriments.caffeine,
        'caffeineServing': product.nutriments.caffeineServing,
        'calcium': product.nutriments.calcium,
        'calciumServing': product.nutriments.calciumServing,
        'iron': product.nutriments.iron,
        'ironServing': product.nutriments.ironServing,
        'vitaminC': product.nutriments.vitaminC,
        'vitaminCServing': product.nutriments.vitaminCServing,
        'magnesium': product.nutriments.magnesium,
        'magnesiumServing': product.nutriments.magnesiumServing,
        'phosphorus': product.nutriments.phosphorus,
        'phosphorusServing': product.nutriments.phosphorusServing,
        'potassium': product.nutriments.potassium,
        'potassiumServing': product.nutriments.potassiumServing,
        'sodium': product.nutriments.sodium,
        'sodiumServing': product.nutriments.sodiumServing,
        'zinc': product.nutriments.zinc,
        'zincServing': product.nutriments.zincServing,
        // 'copper': product.nutriments.copper,
        // 'copperServing': product.nutriments.copperServing,
        // 'selenium': product.nutriments.selenium,
        // 'seleniumServing': product.nutriments.seleniumServing,
        // 'vitaminA': product.nutriments.vitaminA,
        // 'vitaminAServing': product.nutriments.vitaminAServing,
        // 'vitaminE': product.nutriments.vitaminE,
        // 'vitaminEServing': product.nutriments.vitaminEServing,
        // 'vitaminD': product.nutriments.vitaminD,
        // 'vitaminDServing': product.nutriments.vitaminDServing,
        // 'vitaminB1': product.nutriments.vitaminB1,
        // 'vitaminB1Serving': product.nutriments.vitaminB1Serving,
        // 'vitaminB2': product.nutriments.vitaminB2,
        // 'vitaminB2Serving': product.nutriments.vitaminB2Serving,
        // 'vitaminPP': product.nutriments.vitaminPP,
        // 'vitaminPPServing': product.nutriments.vitaminPPServing,
        // 'vitaminB6': product.nutriments.vitaminB6,
        // 'vitaminB6Serving': product.nutriments.vitaminB6Serving,
        // 'vitaminK': product.nutriments.vitaminK,
        // 'vitaminKServing': product.nutriments.vitaminKServing,
        // 'vitaminB12': product.nutriments.vitaminB12,
        // 'vitaminB12Serving': product.nutriments.vitaminB12Serving,
        // 'vitaminB9': product.nutriments.vitaminB9,
        // 'vitaminB9Serving': product.nutriments.vitaminB9Serving,
        // 'cholesterol': product.nutriments.cholesterol,
        // 'cholesterolServing': product.nutriments.cholesterolServing,
        // 'alcohol': product.nutriments.alcohol,
        // 'alcoholServing': product.nutriments.alcoholServing,
        'monounsaturatedAcid': product.nutriments.monounsaturatedAcid,
        'monounsaturatedServing': product.nutriments.monounsaturatedServing,
        'polyunsaturatedAcid': product.nutriments.polyunsaturatedAcid,
        'polyunsaturatedServing': product.nutriments.polyunsaturatedServing,
      },
      'servingSize': product.servingSize,
      'servingQuantity': product.servingQuantity,
    };
