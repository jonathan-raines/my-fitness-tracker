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
        'saltServing': product.nutriments.saltServing,
        'fiberServing': product.nutriments.fiberServing,
        'sugarsServing': product.nutriments.sugarsServing,
        'fatServing': product.nutriments.fatServing,
        'saturatedFatServing': product.nutriments.saturatedFatServing,
        'proteinsServing': product.nutriments.proteinsServing,
        'energyServing': product.nutriments.energyServing,
        'carbohydratesServing': product.nutriments.carbohydratesServing,
        'caffeineServing': product.nutriments.caffeineServing,
        'calciumServing': product.nutriments.calciumServing,
        'ironServing': product.nutriments.ironServing,
        'vitaminCServing': product.nutriments.vitaminCServing,
        'phosphorusServing': product.nutriments.phosphorusServing,
        'potassiumServing': product.nutriments.potassiumServing,
        'sodiumServing': product.nutriments.sodiumServing,
        'zincServing': product.nutriments.zincServing,
        'copperServing': product.nutriments.copperServing,
        'seleniumServing': product.nutriments.seleniumServing,
        'vitaminAServing': product.nutriments.vitaminAServing,
        'vitaminEServing': product.nutriments.vitaminEServing,
        'vitaminDServing': product.nutriments.vitaminDServing,
        'vitaminB1Serving': product.nutriments.vitaminB1Serving,
        'vitaminB2Serving': product.nutriments.vitaminB2Serving,
        'vitaminB6Serving': product.nutriments.vitaminB6Serving,
        'vitaminB12Serving': product.nutriments.vitaminB12Serving,
        'vitaminB9Serving': product.nutriments.vitaminB9Serving,
        'vitaminKServing': product.nutriments.vitaminKServing,
        'cholesterolServing': product.nutriments.cholesterolServing,
        'magnesiumServing': product.nutriments.magnesiumServing,
        'vitaminPPServing': product.nutriments.vitaminPPServing,
        'alcoholServing': product.nutriments.alcoholServing,
        'monounsaturatedServing': product.nutriments.monounsaturatedServing,
        'polyunsaturatedServing': product.nutriments.polyunsaturatedServing,
        'butyricAcidServing': product.nutriments.butyricAcidServing,
        'capricAcidServing': product.nutriments.capricAcidServing,
        'caproicAcidServing': product.nutriments.caproicAcidServing,
        'caprylicAcidServing': product.nutriments.caprylicAcidServing,
        'docosahexaenoicAcidServing':
            product.nutriments.docosahexaenoicAcidServing,
        'eicosapentaenoicAcidServing':
            product.nutriments.eicosapentaenoicAcidServing,
        'erucicAcidServing': product.nutriments.erucicAcidServing,
        'lauricAcidServing': product.nutriments.lauricAcidServing,
        'linoleicAcidServing': product.nutriments.linoleicAcidServing,
        'myristicAcidServing': product.nutriments.myristicAcidServing,
        'oleicAcidServing': product.nutriments.oleicAcidServing,
        'palmiticAcidServing': product.nutriments.palmiticAcidServing,
        'stearicAcidServing': product.nutriments.stearicAcidServing,
      },
      'servingSize': product.servingSize,
      'servingQuantity': product.servingQuantity,
    };