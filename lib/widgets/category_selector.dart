import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {

  int category_selector;
  Function change_category_selector;
  CategorySelector(this.category_selector,this.change_category_selector);
  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  //int selectedIndex = 0;
  final List<String> categories = ['Messages', 'Friends', 'Discover'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return FlatButton(
            onPressed: () {
              widget.change_category_selector(index);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20.0,
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: index == widget.category_selector ? Colors.white : Colors.white70,
                  fontSize: 21.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
