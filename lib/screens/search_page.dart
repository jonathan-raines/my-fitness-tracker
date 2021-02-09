import 'package:flutter/material.dart';
import 'package:my_fitness_tracker/functions.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchResult result;
  final FocusNode focusNode = FocusNode();
  final myController = TextEditingController();

  List<ListTile> foodResultsTiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for Products'),
        centerTitle: true,
        backgroundColor: Colors.teal.shade600,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  child: Text('Custom Food'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/custom');
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  child: Text('Scan Barcode'),
                  onPressed: () {
                    getProductFromBarcode(context);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    focusNode.unfocus();
                    result = await productSearchKeywords([myController.text]);
                    foodResultsTiles = [];
                    for (Product product in result.products) {
                      if (product.productName != null &&
                          product.servingSize != null) {
                        foodResultsTiles.add(
                          ListTile(
                            title: Text(product.productName ?? ''),
                            trailing:
                                Text('Serving Size: ${product.servingSize}'),
                            onTap: () => Navigator.pushNamed(
                                context, '/details',
                                arguments: product),
                          ),
                        );
                      }
                      setState(() {});
                    }
                  },
                  child: Text('Search'),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: foodResultsTiles,
            ),
          ),
        ],
      ),
    );
  }
}
