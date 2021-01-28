import 'package:flutter/material.dart';
import 'services/open_food.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchKeywords;
  dynamic result;
  FocusNode focusNode = FocusNode();

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
              decoration: InputDecoration(
                hintText: 'Search for product',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                searchKeywords = value;
              },
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () async {
                focusNode.unfocus();
                result = await productSearchKeywords(searchKeywords);
                // TODO Turn result.body into a Product object so it can be added to foodList
                setState(() {
                  _buildProductList = [];
                  for (dynamic product in result['products']) {
                    _buildProductList.add(GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/details',
                              arguments: product);
                        },
                        child: Text(product['product_name'])));
                  }
                });
                //result['products'][0]['nutriscore_score']);
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
