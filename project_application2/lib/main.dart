import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'AlbertSans',
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedBottomIndex = 1;
  String searchQuery = '';
  bool showNoResults = false;
  Set<String> selectedCategories = {};

  final List<Map<String, dynamic>> recipes = [
    {
      'imageUrl': "assets/Idiyappam.jpg",
      'title': "Idiyappam",
      'author': "Priyanthika Malkanthi",
      'rating': 4.7,
      'reviews': 7,
      'canMake': true,
      'category': 'Breakfast',
    },
    {
      'imageUrl': "assets/Bruschetta.jpg",
      'title': "Bruschetta",
      'author': "Kamala Gunasekara",
      'rating': 4.3,
      'reviews': 10,
      'canMake': false,
      'category': 'Snack',
    },
    {
      'imageUrl': "assets/FluffyPancakes.jpg",
      'title': "Fluffy Pancakes",
      'author': "Natasha Wijesekara",
      'rating': 4.0,
      'reviews': 12,
      'canMake': true,
      'category': 'Dessert',
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredRecipes = recipes
        .where((recipe) =>
            recipe['title'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    if (selectedCategories.isNotEmpty) {
      filteredRecipes = filteredRecipes
          .where((recipe) => selectedCategories.contains(recipe['category']))
          .toList();
    }

    showNoResults = searchQuery.isNotEmpty && filteredRecipes.isEmpty;

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
                fontFamily: 'AlbertSans',
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DiscoverPageCategorySection(
                    onCategorySelected: (category) {
                      setState(() {
                        if (selectedCategories.contains(category)) {
                          selectedCategories.remove(category);
                        } else {
                          selectedCategories.add(category);
                        }
                      });
                    },
                    selectedCategories: selectedCategories,
                  ),
                  SizedBox(height: 16),
                  if (showNoResults)
                    Text(
                      "No results found.",
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    Column(
                      children: filteredRecipes.map((recipe) {
                        return Column(
                          children: [
                            RecipeCard(
                              imageUrl: recipe['imageUrl'],
                              title: recipe['title'],
                              author: recipe['author'],
                              rating: recipe['rating'],
                              reviews: recipe['reviews'],
                              canMake: recipe['canMake'],
                            ),
                            SizedBox(height: 16),
                          ],
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          child: BottomNavigationBar(
            currentIndex: selectedBottomIndex,
            onTap: (index) {
              setState(() {
                selectedBottomIndex = index;
              });
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      selectedBottomIndex == 0
                          ? 'assets/HomeIconOnClick.png'
                          : 'assets/home.png',
                      width: 24,
                      height: 24,
                    ),
                    if (selectedBottomIndex == 0)
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        height: 2,
                        width: 24,
                        color: Color(0xFFFFDB4F),
                      ),
                  ],
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      selectedBottomIndex == 1
                          ? 'assets/ExploreIconOnClick.png'
                          : 'assets/search.png',
                      width: 24,
                      height: 24,
                    ),
                    if (selectedBottomIndex == 1)
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        height: 2,
                        width: 24,
                        color: Color(0xFFFFDB4F),
                      ),
                  ],
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      selectedBottomIndex == 2
                          ? 'assets/MyProfileIconOnClick.png'
                          : 'assets/profile.png',
                      width: 24,
                      height: 24,
                    ),
                    if (selectedBottomIndex == 2)
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        height: 2,
                        width: 24,
                        color: Color(0xFFFFDB4F),
                      ),
                  ],
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
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final double rating;
  final int reviews;
  final bool canMake;

  const RecipeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.rating,
    required this.reviews,
    required this.canMake,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1.0,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageUrl,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'AlbertSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    author,
                    style: TextStyle(
                      fontFamily: 'AlbertSans',
                      fontSize: 15,
                      color: Color(0xFFFFDB4F),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontFamily: 'AlbertSans',
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 2),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: Color(0xFFFFDB4F),
                            size: 18,
                          );
                        }),
                      ),
                      SizedBox(width: 2),
                      Text(
                        '($reviews)',
                        style: TextStyle(
                          fontFamily: 'AlbertSans',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  if (canMake)
                    Text(
                      "You can make this food!",
                      style: TextStyle(
                        fontFamily: 'AlbertSans',
                        color: Color(0xFFFFDB4F),
                        fontSize: 15,
                      ),
                    )
                  else
                    Text(
                      "You are missing 4 ingredients.",
                      style: TextStyle(
                        fontFamily: 'AlbertSans',
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoverPageCategorySection extends StatefulWidget {
  final Function(String) onCategorySelected;
  final Set<String> selectedCategories;

  const DiscoverPageCategorySection({
    super.key,
    required this.onCategorySelected,
    required this.selectedCategories,
  });

  @override
  DiscoverPageCategorySectionState createState() =>
      DiscoverPageCategorySectionState();
}

class DiscoverPageCategorySectionState
    extends State<DiscoverPageCategorySection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                widget.onCategorySelected("Dessert");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.selectedCategories.contains("Dessert")
                    ? Color(0xFFFF8210)
                    : Colors.white,
                foregroundColor: widget.selectedCategories.contains("Dessert")
                    ? Colors.white
                    : Color(0xFFFF8210),
                side: BorderSide(color: Color(0xFFFF8210)),
              ),
              child: Text("Dessert"),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onCategorySelected("Breakfast");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.selectedCategories.contains("Breakfast")
                    ? Color(0xFFFF8210)
                    : Colors.white,
                foregroundColor: widget.selectedCategories.contains("Breakfast")
                    ? Colors.white
                    : Color(0xFFFF8210),
                side: BorderSide(color: Color(0xFFFF8210)),
              ),
              child: Text("Breakfast"),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onCategorySelected("Lunch");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.selectedCategories.contains("Lunch")
                    ? Color(0xFFFF8210)
                    : Colors.white,
                foregroundColor: widget.selectedCategories.contains("Lunch")
                    ? Colors.white
                    : Color(0xFFFF8210),
                side: BorderSide(color: Color(0xFFFF8210)),
              ),
              child: Text("Lunch"),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onCategorySelected("Dinner");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.selectedCategories.contains("Dinner")
                    ? Color(0xFFFF8210)
                    : Colors.white,
                foregroundColor: widget.selectedCategories.contains("Dinner")
                    ? Colors.white
                    : Color(0xFFFF8210),
                side: BorderSide(color: Color(0xFFFF8210)),
              ),
              child: Text("Dinner"),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onCategorySelected("Snack");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.selectedCategories.contains("Snack")
                    ? Color(0xFFFF8210)
                    : Colors.white,
                foregroundColor: widget.selectedCategories.contains("Snack")
                    ? Colors.white
                    : Color(0xFFFF8210),
                side: BorderSide(color: Color(0xFFFF8210)),
              ),
              child: Text("Snack"),
            ),
          ],
        ),
      ],
    );
  }
}
