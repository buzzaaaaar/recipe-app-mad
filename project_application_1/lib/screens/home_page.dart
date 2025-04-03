import 'package:flutter/material.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import 'discover_page.dart';

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
      "Grains & Starches",
      4,
      5,
      "assets/icons/GrainsAndStarchesIcon.png",
    ),
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
                            color:
                                selectedTopIndex == 0
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
                            color:
                                selectedTopIndex == 1
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
      body:
          selectedTopIndex == 1
              ? DiscoverPage()
              : LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
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
                                return CategoryCard(
                                  category: categories[index],
                                );
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
