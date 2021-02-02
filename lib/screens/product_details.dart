import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/Product.dart';
import '../constants.dart';

class ProductDetails extends StatelessWidget {
  final myController = TextEditingController();

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
            SizedBox(
              height: 30,
            ),
            Text('Product Name: ${product.productName}'),
            Text('Serving Size: ${product.servingSize}'),
            Text('Protein: ${product.nutriments.proteinsServing}'),
            Text('Carbs: ${product.nutriments.carbohydratesServing}'),
            Text('Fats: ${product.nutriments.fatServing}'),
            Column(
              children: [
                TextButton(
                  child: Text('Add Food'),
                  onPressed: () {
                    foodList.add(product);
                    buildWidget(product);
                    Navigator.pushNamed(context, '/');
                  },
                ),
              ),
            ),
            TextButton(
              child: Text('Add Food'),
              onPressed: () {
                var servingSize = int.parse(myController.text);

                foodList.add(product);
                buildWidget(
                    product.productName,
                    product.nutriments.proteinsServing * servingSize,
                    product.nutriments.carbohydratesServing * servingSize,
                    product.nutriments.fatServing * servingSize);
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
