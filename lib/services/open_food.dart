import 'package:openfoodfacts/model/parameter/SearchTerms.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

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

Future<dynamic> productSearchKeywords(List<String> keywords) async {
  var parameters = <Parameter>[
    SearchTerms(terms: keywords),
    const OutputFormat(format: Format.JSON),
    const Page(page: 1),
    const PageSize(size: 10),
    const SearchSimple(active: true),
    const SortBy(option: SortOption.POPULARITY),
  ];

  ProductSearchQueryConfiguration configuration =
      ProductSearchQueryConfiguration(
          parametersList: parameters,
          fields: [ProductField.ALL],
          language: OpenFoodFactsLanguage.ENGLISH);

  SearchResult result =
      await OpenFoodAPIClient.searchProducts(null, configuration);

  return result;
}
