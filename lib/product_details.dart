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
      body: Column(
        children: [
          // TODO handle situation where serving sizes and macros per serving are not available
          // TODO look into narrowing search to items that contain those nutriment fields
          Text('Product Name: ${product.productName}'),
          Text(
              'Protein: ${product.nutriments.proteinsServing.toInt().toString()}'),
          Text(
              'Carbs: ${product.nutriments.carbohydratesServing.toInt().toString()}'),
          Text('Fats: ${product.nutriments.fatServing.toInt().toString()}'),
          Column(
            children: [
              TextButton(
                child: Text('Add Food'),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
