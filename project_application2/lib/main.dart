import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedBottomIndex = 1; // Set to 1 to highlight Explore on launch

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
                  DiscoverPageCategorySection(), // Added Category Section here
                  SizedBox(height: 16),
                  Text(
                    "🔥 Trending Recipes",
                    style: TextStyle(
                      fontFamily: 'AlbertSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 16),
                  RecipeCard(
                    imageUrl:
                        "assets/Idiyappam.png", // Replace with your image path
                    title: "Idiyappam",
                    author: "Priyanthika Malkanthi",
                    rating: 4.7,
                    reviews: 7,
                    canMake: true,
                  ),
                  SizedBox(height: 16),
                  RecipeCard(
                    imageUrl: "assets/bruschetta.png",
                    title: "Bruschetta",
                    author: "Kamala Gunasekara",
                    rating: 4.3,
                    reviews: 10,
                    canMake: false,
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
                          ? 'assets/icons/HomeIconOnClick.png'
                          : 'assets/icons/HomeIcon.png',
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
                          ? 'assets/icons/ExploreIconOnClick.png'
                          : 'assets/icons/ExploreIcon.png',
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
                          ? 'assets/icons/MyProfileIconOnClick.png'
                          : 'assets/icons/MyProfileIcon.png',
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

  RecipeCard({
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
          Container(
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
  @override
  _DiscoverPageCategorySectionState createState() =>
      _DiscoverPageCategorySectionState();
}

class _DiscoverPageCategorySectionState
    extends State<DiscoverPageCategorySection> {
  Set<String> selectedCategories = Set();

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
      ],
    );
  }
}
