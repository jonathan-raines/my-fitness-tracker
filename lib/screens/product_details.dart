import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_fitness_tracker/services.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();
  final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  int weight = 0;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 150,
              child: ListView(
                children: [
                  Text('Name: ${product.productName}'),
                  Text('Serving Size: ${product.servingSize}'),
                  Text(
                      'Protein per Serving: ${product.nutriments.proteinsServing}'),
                  Text(
                      'Carbohydrates per Serving: ${product.nutriments.carbohydratesServing}'),
                  Text('Fats per Serving: ${product.nutriments.fatServing}'),
                  Text(
                      'Saturated Fats per Serving: ${product.nutriments.saturatedFatServing.round()}'),
                  Text(
                      'Salt per Serving: ${product.nutriments.saltServing.round()}'),
                ],
              ),
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
                    controller: _controller,
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
                    /* product.nutriments.proteinsServing *=
                        int.parse(_controller.text);
                    product.nutriments.carbohydratesServing *=
                        int.parse(_controller.text);
                    product.nutriments.fatServing *=
                        int.parse(_controller.text); */

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
