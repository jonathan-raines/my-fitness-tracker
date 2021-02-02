import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import '../services.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchResult result;
  final FocusNode focusNode = FocusNode();
  final myController = TextEditingController();

  List<Widget> _buildProductList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for Products'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: TextField(
              focusNode: focusNode,
              controller: myController,
              decoration: InputDecoration(
                hintText: 'Search for product',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () async {
                focusNode.unfocus(); // hide keyboard upon starting search
                result = await productSearchKeywords([myController.text]);

                setState(() {
                  _buildProductList = [];
                  for (Product product in result.products) {
                    _buildProductList.add(
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/details',
                            arguments: product),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Name: ${product.productName}',
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Protein: ${product.nutriments.proteinsServing}',
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Carbs: ${product.nutriments.carbohydratesServing}',
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Fats: ${product.nutriments.fatServing}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                });
              },
              child: Text('Search'),
            ),
          ),
          Column(
            children: _buildProductList,
          ),
        ],
      ),
    );
  }
}
