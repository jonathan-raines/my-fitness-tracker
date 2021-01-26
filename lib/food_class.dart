import 'package:openfoodfacts/model/Product.dart';

import 'package:openfoodfacts/openfoodfacts.dart';

class Food extends Product {
  final product;

  Food({this.product});

  double calculateCalories() {
    return (this.product.nutriments.proteinsServing * 4) +
        (this.product.nutriments.fatServing * 9) +
        (this.product.nutriments.carbohydratesServing * 4);
  }
}
