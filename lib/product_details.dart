import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'constants.dart';

class ProductDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network('${product.imgSmallUrl}'),
            Text('Product Name: ${product.productName}'),
            Text('Protein: ${product.nutriments.proteinsServing}'),
            Text('Carbs: ${product.nutriments.carbohydratesServing}'),
            Text('Fats: ${product.nutriments.fatServing}'),
            Column(
              children: [
                TextButton(
                  child: Text('Add Food'),
                  onPressed: () {
                    foodList.add(product);
                    buildWidget(
                        product.productName,
                        product.nutriments.proteinsServing,
                        product.nutriments.carbohydratesServing,
                        product.nutriments.fatServing);
                    Navigator.pushNamed(context, '/');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
