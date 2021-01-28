import 'dart:convert';

import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:http/http.dart' as http;

Future<Product> getProduct(String barcode) async {
  ProductQueryConfiguration configurations = ProductQueryConfiguration(barcode,
      language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);

  ProductResult result = await OpenFoodAPIClient.getProduct(configurations);

  if (result.status == 1) {
    return result.product;
  } else {
    throw new Exception("product not found, please insert data for " + barcode);
  }
}

Future<dynamic> productSearchKeywords(String keywords) async {
  final String url =
      'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$keywords&search_simple=1&action=process&json=1';
  final response = await http.get(url);

  return json.decode(response.body);
}
