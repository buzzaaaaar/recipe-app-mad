import 'package:flutter/material.dart';
import '../widgets/recipe_card.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Set<String> selectedCategories = Set();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "You can make 2 recipes.",
                style: TextStyle(
                  fontFamily: 'AlbertSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Category",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (selectedCategories.contains("Dessert")) {
                        selectedCategories.remove("Dessert");
                      } else {
                        selectedCategories.add("Dessert");
                      }
                    });
                  },
                  child: Text("Dessert"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategories.contains("Dessert")
                        ? Color(0xFFFF8210)
                        : Colors.white,
                    foregroundColor: selectedCategories.contains("Dessert")
                        ? Colors.white
                        : Color(0xFFFF8210),
                    side: BorderSide(color: Color(0xFFFF8210)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (selectedCategories.contains("Breakfast")) {
                        selectedCategories.remove("Breakfast");
                      } else {
                        selectedCategories.add("Breakfast");
                      }
                    });
                  },
                  child: Text("Breakfast"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategories.contains("Breakfast")
                        ? Color(0xFFFF8210)
                        : Colors.white,
                    foregroundColor: selectedCategories.contains("Breakfast")
                        ? Colors.white
                        : Color(0xFFFF8210),
                    side: BorderSide(color: Color(0xFFFF8210)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (selectedCategories.contains("Lunch")) {
                        selectedCategories.remove("Lunch");
                      } else {
                        selectedCategories.add("Lunch");
                      }
                    });
                  },
                  child: Text("Lunch"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategories.contains("Lunch")
                        ? Color(0xFFFF8210)
                        : Colors.white,
                    foregroundColor: selectedCategories.contains("Lunch")
                        ? Colors.white
                        : Color(0xFFFF8210),
                    side: BorderSide(color: Color(0xFFFF8210)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (selectedCategories.contains("Dinner")) {
                        selectedCategories.remove("Dinner");
                      } else {
                        selectedCategories.add("Dinner");
                      }
                    });
                  },
                  child: Text("Dinner"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategories.contains("Dinner")
                        ? Color(0xFFFF8210)
                        : Colors.white,
                    foregroundColor: selectedCategories.contains("Dinner")
                        ? Colors.white
                        : Color(0xFFFF8210),
                    side: BorderSide(color: Color(0xFFFF8210)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (selectedCategories.contains("Snack")) {
                        selectedCategories.remove("Snack");
                      } else {
                        selectedCategories.add("Snack");
                      }
                    });
                  },
                  child: Text("Snack"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategories.contains("Snack")
                        ? Color(0xFFFF8210)
                        : Colors.white,
                    foregroundColor: selectedCategories.contains("Snack")
                        ? Colors.white
                        : Color(0xFFFF8210),
                    side: BorderSide(color: Color(0xFFFF8210)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            RecipeCard(
              imageUrl: "assets/FluffyPancakes.png",
              title: "Fluffy Pancakes",
              author: "Natasha Wijesekara",
              rating: 4.0,
              reviews: 12,
              canMake: true,
            ),
            SizedBox(height: 16),
            RecipeCard(
              imageUrl: "assets/ChocolateChipCookies.png",
              title: "Chocolate Chip Cookies",
              author: "Javindu Gunasekara",
              rating: 3.2,
              reviews: 23,
              canMake: false,
            ),
          ],
        ),
      ),
    );
  }
}