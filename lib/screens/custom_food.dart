import 'package:flutter/material.dart';
import 'package:my_fitness_tracker/functions.dart';
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

  void calculateMacrosPer100Gram() {
    customNutriments.proteins = (customNutriments.proteinsServing /
        double.parse(customProduct.servingSize) *
        100);
    customNutriments.carbohydrates = (customNutriments.carbohydratesServing /
        double.parse(customProduct.servingSize) *
        100);
    customNutriments.fat = (customNutriments.fatServing /
        double.parse(customProduct.servingSize) *
        100);
    customNutriments.energyKcal100g = (customNutriments.proteins * 4) +
        (customNutriments.carbohydrates * 4) +
        (customNutriments.fat * 9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('Add Custom Food'),
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
                  validator: emptyStringValidator,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Serving Size'),
                  onSaved: (value) => customProduct.servingSize = value,
                  validator: emptyStringValidator,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: 'Calories per Serving'),
                  onSaved: (value) =>
                      customNutriments.energyServing = double.parse(value),
                  validator: emptyStringValidator,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Protein per Serving'),
                  onSaved: (value) =>
                      customNutriments.proteinsServing = double.parse(value),
                  validator: emptyStringValidator,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: 'Carbohydrates per Serving'),
                  onSaved: (String grams) => customNutriments
                      .carbohydratesServing = double.parse(grams),
                  validator: emptyStringValidator,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Fat per Serving'),
                  onSaved: (String grams) =>
                      customNutriments.fatServing = double.parse(grams),
                  validator: emptyStringValidator,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        calculateMacrosPer100Gram();
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
