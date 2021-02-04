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
  final myController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  int selectedMealNumber = 1;

  List<Widget> showProductDetails(Product product) {
    List<Widget> productDetails = [];
    toMap(product).forEach((k, v) => {productDetails.add(Text('$k: $v'))});
    return productDetails;
  }

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: showProductDetails(product),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: myController,
              decoration: InputDecoration(
                hintText: 'Servings: ',
                border: OutlineInputBorder(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Meal Number: '),
                androidDropdown(),
              ],
            ),
            TextButton(
              child: Text('Add Food'),
              onPressed: () {
                var docRef = _firestore
                    .collection('users')
                    .doc(_auth.currentUser.uid)
                    .collection('date')
                    .doc(formattedDate)
                    .collection('meals')
                    .doc(selectedMealNumber.toString());

                docRef.get().then((doc) => {
                      if (doc.exists)
                        {
                          docRef.update({
                            'foods': FieldValue.arrayUnion([toMap(product)])
                          })
                        }
                      else
                        {
                          docRef.set({
                            'foods': [toMap(product)]
                          })
                        }
                    });
                Navigator.pushNamed(context, '/diary');
              },
            ),
          ],
        ),
      ),
    );
  }
}
