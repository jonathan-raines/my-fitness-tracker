import 'package:flutter/material.dart';
import 'services/open_food.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchKeywords;
  dynamic result;

  Widget getQueryResults() {
    //List<Widget> widgets = [];

    //widgets.add(Text(result['products'][0]['brands']));

    try {
      return Text(result['products'][0]['product_name_fr']);
    } catch (e) {
      return Text('No food entered');
    }
  }

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
                result = await productSearchKeywords(searchKeywords);

                setState(() {
                  getQueryResults();
                });
              },
              child: Text('Search'),
            ),
          ),
          getQueryResults() ?? Text(''),
        ],
      ),
    );
  }
}
