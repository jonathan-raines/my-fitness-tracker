import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/Product.dart';

class ProductDetails extends StatelessWidget {
  final myController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
            SizedBox(
              height: 30,
            ),
            Text('Product Name: ${product.productName}'),
            Text('Serving Size: ${product.servingSize}'),
            Text('Protein: ${product.nutriments.proteinsServing}'),
            Text('Carbs: ${product.nutriments.carbohydratesServing}'),
            Text('Fats: ${product.nutriments.fatServing}'),
            SizedBox(
              height: 30,
            ),

            // TODO Create drop down menu for grams or servings and calculate accordingly
            // TODO Create multiplier by taking number of grams divided by serving size
            SizedBox(
              height: 50,
              width: 100,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: myController,
                decoration: InputDecoration(
                  hintText: 'Servings: ',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            TextButton(
              child: Text('Add Food'),
              onPressed: () {


                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
