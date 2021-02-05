import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_fitness_tracker/services.dart';
import 'package:openfoodfacts/model/Nutriments.dart';
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

  int weight = 1;
  int selectedMealNumber = 1;

  DropdownButton<int> androidDropdown() {
    List<DropdownMenuItem<int>> dropdownItems = [];
    for (var i = 1; i < 6; i++) {
      var newItem = DropdownMenuItem(
        child: Text('$i'),
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
          print(selectedMealNumber);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context).settings.arguments;
    int calories = (((product.nutriments.proteinsServing * 4) +
                    (product.nutriments.carbohydratesServing * 4) +
                    (product.nutriments.fatServing * 9)) /
                10.0)
            .round() *
        10;
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Colors.teal.shade600,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      'Name: ',
                      style: TextStyle(fontSize: 24.0, fontFamily: 'Lato'),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      product.productName,
                      style: TextStyle(fontSize: 24.0, fontFamily: 'Lato'),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      'Serving Size: ',
                      style: TextStyle(fontSize: 24.0, fontFamily: 'Lato'),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      product.servingSize,
                      style: TextStyle(fontSize: 24.0, fontFamily: 'Lato'),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      'Calories: ',
                      style: TextStyle(fontSize: 24.0, fontFamily: 'Lato'),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '$calories',
                      style: TextStyle(fontSize: 24.0, fontFamily: 'Lato'),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      'Protein: ',
                      style: TextStyle(fontSize: 24.0, fontFamily: 'Lato'),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${product.nutriments.proteinsServing.round()} g',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'Lato',
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      'Carbohydrates: ',
                      style: TextStyle(fontSize: 24.0, fontFamily: 'Lato'),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${product.nutriments.carbohydratesServing.round()} g',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'Lato',
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      'Fats: ',
                      style: TextStyle(fontSize: 24.0, fontFamily: 'Lato'),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${product.nutriments.fatServing.round()} g',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'Lato',
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      'Sugars: ',
                      style: TextStyle(fontSize: 24.0, fontFamily: 'Lato'),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${product.nutriments.sugarsServing.round()} g',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'Lato',
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 5,
              thickness: 3.0,
              color: Colors.black38,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(),
                    onChanged: (value) {
                      weight = int.parse(value);
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Text('Meal Number: '),
                androidDropdown(),
                TextButton(
                  child: Text('Add Food'),
                  onPressed: () {
                    if (weight > 1) {
                      product.nutriments = Nutriments(
                        proteinsServing:
                            weight * product.nutriments.proteinsServing,
                        fatServing: weight * product.nutriments.fatServing,
                        carbohydratesServing:
                            weight * product.nutriments.carbohydratesServing,
                        saltServing: weight * product.nutriments.saltServing,
                        saturatedFatServing:
                            weight * product.nutriments.saturatedFatServing,
                        sugarsServing:
                            weight * product.nutriments.sugarsServing,
                        sodiumServing:
                            weight * product.nutriments.sodiumServing,
                        fiberServing: weight * product.nutriments.fiberServing,
                      );
                    }

                    var docRef = _firestore
                        .collection('users')
                        .doc(_auth.currentUser.uid)
                        .collection('date')
                        .doc(formattedDate)
                        .collection('meals')
                        .doc('Meal $selectedMealNumber');

                    docRef.get().then((doc) => {
                          doc.exists
                              ? docRef.update({
                                  'foods':
                                      FieldValue.arrayUnion([toMap(product)])
                                })
                              : docRef.set({
                                  'foods': [toMap(product)]
                                })
                        });
                    Navigator.pushNamed(context, '/diary');
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
