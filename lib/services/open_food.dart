import 'package:openfoodfacts/model/parameter/SearchTerms.dart';
import 'package:openfoodfacts/model/parameter/TagFilter.dart';
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

Future<SearchResult> searchProduct() async {
  var parameters = [
    const OutputFormat(format: Format.JSON),
    const PageSize(size: 15),
    const SortBy(option: SortOption.POPULARITY),
    const SearchSimple(active: true),
    const SearchTerms(terms: ['kellog\'s', 'frosted', 'flakes']),
    const TagFilter(
        tagType: "categories", contains: true, tagName: "breakfast_cereals")
  ];

  ProductSearchQueryConfiguration configuration =
      ProductSearchQueryConfiguration(
    parametersList: parameters,
    fields: [ProductField.ALL],
  );

  return await OpenFoodAPIClient.searchProducts(null, configuration);
}
