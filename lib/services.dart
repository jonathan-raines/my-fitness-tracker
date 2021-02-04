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
        'monounsaturatedAcid': product.nutriments.monounsaturatedAcid,
        'monounsaturatedServing': product.nutriments.monounsaturatedServing,
        'polyunsaturatedAcid': product.nutriments.polyunsaturatedAcid,
        'polyunsaturatedServing': product.nutriments.polyunsaturatedServing,
      },
      'servingSize': product.servingSize,
      'servingQuantity': product.servingQuantity,
    };

Product fromMap(
        Map<String, dynamic> productMap, Map<String, dynamic> nutrimentMap) =>
    Product(
        barcode: productMap['barcode'],
        brands: productMap['brands'],
        productName: productMap['productName'],
        servingQuantity: productMap['servingQuantity'],
        servingSize: productMap['servingSize'],
        nutriments: nutrimentsFromMap(nutrimentMap));

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
