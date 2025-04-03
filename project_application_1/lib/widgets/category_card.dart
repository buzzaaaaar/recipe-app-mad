import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryCard extends StatefulWidget {
  final Category category;

  CategoryCard({required this.category});

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool isExpanded = false;
  Set<String> selectedItems = Set();

  final Map<String, List<String>> items = {
    "Vegetables": ["Bell Pepper", "Broccoli", "Cabbage", "Carrot", "Spinach"],
    "Fruits": ["Apple", "Banana", "Orange", "Grapes", "Mango"],
    "Proteins": ["Chicken", "Eggs", "Tofu", "Fish", "Beef"],
    "Grains & Starches": ["Rice", "Pasta", "Potatoes", "Bread", "Quinoa"]
  };

  @override
  Widget build(BuildContext context) {
    List<String> categoryItems = items[widget.category.name] ?? [];
    int selectedCount = selectedItems.length;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Image.asset(
              widget.category.iconPath,
              width: 60,
              height: 60,
            ),
            title: Text(
              widget.category.name,
              style: TextStyle(
                fontFamily: 'Albert Sans',
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            subtitle: Text(
              "$selectedCount/${widget.category.total}",
              style: TextStyle(
                fontFamily: 'Albert Sans',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Color(0xFFFFDB4F),
            ),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: categoryItems.map((item) {
                  bool isSelected = selectedItems.contains(item);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedItems.remove(item);
                        } else {
                          if (selectedItems.length < widget.category.total) {
                            selectedItems.add(item);
                          }
                        }
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Color(0xFFFFDB4F) : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        item,
                        style: TextStyle(
                          color: isSelected ? Color(0xFFFFDB4F) : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}