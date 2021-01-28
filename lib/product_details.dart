import 'package:flutter/material.dart';
import 'constants.dart';

class ProductDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Column(
        children: [
          // TODO handle situation where serving sizes and macros per serving are not available
          Text(arguments['product_name']),
          Text('Serving Size: ${arguments['serving_size']}'),
          Text('Calories: ${arguments['nutriments']['energy-kcal_serving']}'),
          Text('Protein: ${arguments['nutriments']['proteins_serving']}'),
          Text('Carbs: ${arguments['nutriments']['carbohydrates_serving']}'),
          Text('Fats: ${arguments['nutriments']['fat_serving']}'),
          Column(
            children: [
              TextButton(
                child: Text('Add Food'),
                onPressed: () {
                  buildWidget(
                    arguments['product_name'],
                    arguments['nutriments']['proteins_serving'].toDouble(),
                    arguments['nutriments']['carbohydrates_serving'].toDouble(),
                    arguments['nutriments']['fat_serving'].toDouble(),
                  );
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
