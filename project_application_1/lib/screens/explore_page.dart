import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/home_page.dart';
import '../pages/profilePage.dart';
import '../models/recipe_model.dart';
import '../recipepage.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  ExplorePageState createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage> {
  int selectedBottomIndex = 1;
  String searchQuery = '';
  bool showNoResults = false;
  bool isLoading = true;
  Set<String> selectedCategories = {};
  List<Recipe> allRecipes = [];
  List<Recipe> filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    _fetchAllRecipes();
  }

  Future<void> _fetchAllRecipes() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('recipes')
              .orderBy('createdAt', descending: true)
              .get();

      setState(() {
        allRecipes =
            snapshot.docs
                .map((doc) => Recipe.fromMap(doc.data(), doc.id))
                .toList();
        filteredRecipes = allRecipes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching recipes: $e');
    }
  }

  void _filterRecipes() {
    setState(() {
      if (searchQuery.isEmpty) {
        filteredRecipes = allRecipes;
      } else {
        filteredRecipes =
            allRecipes.where((recipe) {
              return recipe.name.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  recipe.category.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  recipe.author.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );
            }).toList();
      }

      if (selectedCategories.isNotEmpty) {
        filteredRecipes =
            filteredRecipes.where((recipe) {
              return selectedCategories.contains(recipe.category);
            }).toList();
      }

      showNoResults = searchQuery.isNotEmpty && filteredRecipes.isEmpty;
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else {
      setState(() {
        selectedBottomIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Explore",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF8210),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4),
              height: 2,
              width: MediaQuery.of(context).size.width,
              color: Color(0xFFFF8210),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                  _filterRecipes();
                },
                decoration: InputDecoration(
                  hintText: "Search for a recipe...",
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF9B9B9B),
                  ),
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),

            // Category filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children:
                    [
                      'All',
                      'Breakfast',
                      'Lunch & Dinner',
                      'Desserts',
                      'Snacks',
                      'Vegetarian',
                    ].map((category) {
                      final isSelected =
                          category == 'All'
                              ? selectedCategories.isEmpty
                              : selectedCategories.contains(category);
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (category == 'All') {
                                selectedCategories.clear();
                              } else {
                                if (selected) {
                                  selectedCategories.add(category);
                                } else {
                                  selectedCategories.remove(category);
                                }
                              }
                              _filterRecipes();
                            });
                          },
                          selectedColor: Color(0xFFFFDB4F),
                          checkmarkColor: Colors.black,
                        ),
                      );
                    }).toList(),
              ),
            ),

            SizedBox(height: 16),

            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (showNoResults)
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "No recipes found matching your search",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = filteredRecipes[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8),
                        leading:
                            recipe.imageUrl != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    recipe.imageUrl!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.broken_image, size: 40),
                                  ),
                                )
                                : Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.fastfood, size: 30),
                                ),
                        title: Text(
                          recipe.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("By ${recipe.author}"),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "4.5",
                                ), // You might want to add rating to your model
                                SizedBox(width: 8),
                                Text(recipe.category),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipePage(recipe: recipe),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedBottomIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              selectedBottomIndex == 0
                  ? 'assets/HomeIconOnClick.png'
                  : 'assets/home.png',
              width: 24,
              height: 24,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              selectedBottomIndex == 1
                  ? 'assets/ExploreIconOnClick.png'
                  : 'assets/search.png',
              width: 24,
              height: 24,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              selectedBottomIndex == 2
                  ? 'assets/MyProfileIconOnClick.png'
                  : 'assets/profile.png',
              width: 24,
              height: 24,
            ),
            label: '',
          ),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedIconTheme: IconThemeData(color: Colors.orange),
        unselectedIconTheme: IconThemeData(color: Colors.grey),
      ),
    );
  }
}
