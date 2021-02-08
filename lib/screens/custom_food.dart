import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/Nutriments.dart';
import 'package:openfoodfacts/model/Product.dart';

class CustomProductForm extends StatefulWidget {
  @override
  _CustomProductFormState createState() => _CustomProductFormState();
}

class _CustomProductFormState extends State<CustomProductForm> {
  final _formKey = GlobalKey<FormState>();
  final Product customProduct = Product();
  final Nutriments customNutriments = Nutriments();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Custom Food'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Product Name'),
                  onSaved: (value) => customProduct.productName = value,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Serving Size'),
                  onSaved: (value) => customProduct.servingSize = value,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: 'Calories per Serving'),
                  onSaved: (value) {
                    customNutriments.energyServing = double.parse(value);
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Protein per Serving'),
                  onSaved: (value) {
                    customNutriments.proteinsServing = double.parse(value);
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: 'Carbohydrates per Serving'),
                  onSaved: (String grams) => customNutriments
                      .carbohydratesServing = double.parse(grams),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Fat per Serving'),
                  onSaved: (String grams) =>
                      customNutriments.fatServing = double.parse(grams),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        customProduct.nutriments = customNutriments;

                        Navigator.popAndPushNamed(context, '/details',
                            arguments: customProduct);
                      }
                    },
                    child: Text('Submit'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
