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
  int selectedBottomIndex = 0;
  int selectedTopIndex = 0;

  final List<Category> categories = [
    Category("Vegetables", 2, 5, "assets/icons/VegetablesIcon.png"),
    Category("Fruits", 3, 5, "assets/icons/FruitsIcon.png"),
    Category("Proteins", 0, 5, "assets/icons/ProteinsIcon.png"),
    Category(
        "Grains & Starches", 4, 5, "assets/icons/GrainsAndStarchesIcon.png")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTopIndex = 0;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          "My Pantry",
                          style: TextStyle(
                            fontFamily: 'AlbertSans',
                            fontSize: 18,
                            color: selectedTopIndex == 0
                                ? Colors.orange
                                : Colors.black,
                          ),
                        ),
                        if (selectedTopIndex == 0)
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            height: 2,
                            width: 80,
                            color: Colors.orange,
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTopIndex = 1;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          "Discover",
                          style: TextStyle(
                            fontFamily: 'AlbertSans',
                            fontSize: 18,
                            color: selectedTopIndex == 1
                                ? Colors.orange
                                : Colors.black,
                          ),
                        ),
                        if (selectedTopIndex == 1)
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            height: 2,
                            width: 80,
                            color: Colors.orange,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: selectedTopIndex == 1
          ? DiscoverPage()
          : LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Select the ingredients in your pantry to discover recipes you can make.",
                              style: TextStyle(
                                fontFamily: 'AlbertSans',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF000000),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 16),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return CategoryCard(category: categories[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
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

class Category {
  final String name;
  final int selected;
  final int total;
  final String iconPath;

  Category(this.name, this.selected, this.total, this.iconPath);
}

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
                      "You are missing 2 ingredients.",
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
