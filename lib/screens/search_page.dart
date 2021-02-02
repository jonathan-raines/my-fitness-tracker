import 'package:flutter/material.dart';
import 'package:my_fitness_tracker/services/open_food.dart';
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
                focusNode.unfocus();
                result = await productSearchKeywords([myController.text]);
                foodResultsTiles = [];
                for (Product product in result.products) {
                  if (product.productName != null && product.servingSize != null) {
                    foodResultsTiles.add(
                      ListTile(
                        title: Text(product.productName ?? ''),
                        trailing: Text('Serving Size: ${product.servingSize}'),
                        onTap: () => Navigator.pushNamed(context, '/details', arguments: product),
                      ),
                    );
                  }
                  setState(() {});
                }
              },
              child: Text('Search'),
            ),
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
