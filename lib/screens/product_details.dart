import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_fitness_tracker/functions.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  double foodWeight = 1;
  int selectedMealNumber = 1;
  bool logByWeight = true;

  DropdownButton<int> androidDropdown() {
    List<DropdownMenuItem<int>> dropdownItems = [];
    for (var i = 1; i < 6; i++) {
      var newItem = DropdownMenuItem(
        child: Text('Meal $i'),
        value: i,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<int>(
      value: selectedMealNumber,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedMealNumber = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context).settings.arguments;
    product.nutriments.energyServing =
        (((product.nutriments.proteinsServing * 4) +
                        (product.nutriments.carbohydratesServing * 4) +
                        (product.nutriments.fatServing * 9)) /
                    10.0)
                .roundToDouble() *
            10;
    return Scaffold(
      appBar: buildAppBar('Product Details'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              productDetailsWidget(product.productName, 'Name'),
              productDetailsWidget(product.servingSize, 'Serving Size'),
              productDetailsWidget(
                  '${product.nutriments.energyServing.round().toString()}',
                  'Calories'),
              productDetailsWidget(
                  '${product.nutriments.proteinsServing.round().toString()} g',
                  'Protein'),
              productDetailsWidget(
                  '${product.nutriments.carbohydratesServing.round().toString()} g',
                  'Carbohydrates'),
              productDetailsWidget(
                  '${product.nutriments.fatServing.round().toString()} g',
                  'Fats'),
              productDetailsDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Number of Servings',
                      style: TextStyle(fontFamily: 'Lato', fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 60),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 12)),
                        onChanged: (value) {
                          foodWeight = double.parse(value);
                        },
                      ),
                      alignment: Alignment.topLeft,
                    ),
                  ),
                  Expanded(
                    child: DropdownButton(
                        value: logByWeight,
                        items: [
                          DropdownMenuItem(
                            child: Text('1 g'),
                            value: true,
                          ),
                          DropdownMenuItem(
                            child: Text('${product.servingSize}'),
                            value: false,
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            logByWeight = value;
                          });
                        }),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Add to Meal',
                        style: TextStyle(fontFamily: 'Lato', fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: androidDropdown(),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.only(bottom: 12),
                  width: 300,
                  height: 50,
                  child: Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal.shade600,
                      ),
                      child: Text('Add Food'),
                      onPressed: () {
                        DocumentReference docRef = getMealReference();
                        docRef.get().then((doc) => {
                              doc.exists
                                  ? docRef.update({
                                      'foods': FieldValue.arrayUnion([
                                        productToMap(
                                            product, foodWeight, logByWeight)
                                      ]),
                                    })
                                  : docRef.set({
                                      'foods': [
                                        productToMap(
                                            product, foodWeight, logByWeight)
                                      ]
                                    })
                            });
                        Navigator.popUntil(
                            context, (ModalRoute.withName('/diary')));
                      },
                    ),
                  ),
                ),
              ),
              productDetailsDivider(),
            ],
          ),
        ),
      ),
    );
  }

  DocumentReference getMealReference() => _firestore
      .collection('users')
      .doc(_auth.currentUser.uid)
      .collection('date')
      .doc(formattedDate)
      .collection('meals')
      .doc('Meal $selectedMealNumber');

  Divider productDetailsDivider() {
    return Divider(
      height: 5,
      thickness: 3.0,
      color: Colors.black38,
    );
  }

  Padding productDetailsWidget(String info, String title) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              '$title: ',
              style: TextStyle(fontSize: 24.0, fontFamily: 'Lato'),
            ),
          ),
          Expanded(
            child: Text(
              info,
              style: TextStyle(fontSize: 24.0, fontFamily: 'Lato'),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
