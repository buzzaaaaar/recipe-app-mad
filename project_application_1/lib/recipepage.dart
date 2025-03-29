import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: RecipePage(),
    );
  }
}

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  RecipePageState createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  int selectedBottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFDB4F), // Background color
      appBar: AppBar(
        backgroundColor: Colors.white, // App bar color
        title: Center(
          child: Text(
            'Recipe',
            style: TextStyle(
              fontFamily: 'AlbertSans', // Font family
              fontWeight: FontWeight.w600, // Semibold
              color: Color(0xFFFF8210), // Title color
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: Color(0xFFFF8210)), // Horizontal three-dot icon
            onPressed: () {
              _showMenu(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Border separating the navigation bar and the content
          Container(
            height: 2,
            // ignore: deprecated_member_use
            color: const Color.fromARGB(255, 234, 113, 15).withOpacity(0.2), // Border color
          ),
          Expanded(
            child: SingleChildScrollView( // Enable scrolling
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9, // Increased width with margin
                  decoration: BoxDecoration(
                    color: Colors.white, // Box color
                    borderRadius: BorderRadius.circular(20), // Curved corners
                  ),
                  padding: const EdgeInsets.all(16), // Padding inside the box
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🔵 Circular Image
                      CircleAvatar(
                        radius: 80, // Increased image size
                        backgroundImage: AssetImage('assets/cookies.png'), // Image path updated
                        onBackgroundImageError: (_, __) => const Icon(Icons.broken_image, size: 50),
                      ),
                      const SizedBox(height: 16),

                      // 🏷 Recipe Title
                      const Text(
                        "Chocolate Chip Cookies",
                        style: TextStyle(
                          fontSize: 46, // Increased font size
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // ⭐ Rating and Review Count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("3.2 ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Icon(Icons.star, color: Colors.orange, size: 20),
                          Icon(Icons.star, color: Colors.orange, size: 20),
                          Icon(Icons.star, color: Colors.orange, size: 20),
                          Icon(Icons.star, color: Colors.orange, size: 20),
                          Icon(Icons.star_border, color: Colors.orange, size: 20),
                          Text(" (23)"),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // ✍ Author and Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Javindu Gunasekara",
                            style: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Text("July 18th, 2024"),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 🔘 SAVE & RATE Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildButton("SAVE", Colors.orange),
                          const SizedBox(width: 16),
                          _buildButton("RATE", Color(0xFF0EDDD2)), // Rate button color updated
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 📦 Recipe Info Box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("🍽 Prep time: 15 minutes", style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF9B9B9B))),
                            Text("🍽 Cook time: 12 minutes", style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF9B9B9B))),
                            Text("🍽 Total time: 27 minutes", style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF9B9B9B))),
                            Text("🍽 Servings: 24 cookies", style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF9B9B9B))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 📝 Ingredients Section
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ingredients",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0EDDD2)), // Color updated
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("• 1 cup unsalted butter, softened", style: TextStyle(color: Colors.black)),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("• ¾ cup brown sugar", style: TextStyle(color: Colors.black)),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("• ¾ cup white sugar", style: TextStyle(color: Colors.black)),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("• 2 eggs", style: TextStyle(color: Colors.black)),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("• 2 tsp vanilla extract", style: TextStyle(color: Colors.black)),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("• 2 ½ cups all-purpose flour", style: TextStyle(color: Colors.black)),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("• 1 tsp baking soda", style: TextStyle(color: Colors.black)),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("• ½ tsp salt", style: TextStyle(color: Colors.black)),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("• 2 cups chocolate chips", style: TextStyle(color: Colors.black)),
                      ),
                      const SizedBox(height: 16),

                      // 📜 Directions Section
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Directions",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0EDDD2)), // Color updated
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("1. Preheat oven to 350°F (175°C). Line a baking sheet with parchment paper.", style: TextStyle(color: Colors.black)),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("2. In a bowl, cream together butter, brown sugar, and white sugar.", style: TextStyle(color: Colors.black)),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("3. Add eggs and vanilla, mixing until smooth.", style: TextStyle(color: Colors.black)),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("4. Sift in flour, baking soda, and salt. Stir to combine.", style: TextStyle(color: Colors.black)),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("5. Fold in chocolate chips. Drop spoonful of dough onto the baking sheet.", style: TextStyle(color: Colors.black)),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("6. Bake for 10–12 minutes until golden brown. Let cool before serving.", style: TextStyle(color: Colors.black)),
                      ),
                      const SizedBox(height: 16),

                      // 📊 Nutritional Information Section
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Nutritional Information (per serving)",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0EDDD2)), // Color updated
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Calories: 160kcal | Protein: 2g | Carbs: 22g | Fat: 8g", style: TextStyle(color: Colors.black)),
                      ),
                      const SizedBox(height: 16),

                      // 📹 Tutorial Section
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Tutorial",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0EDDD2)), // Color updated
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 200, // Height for video box
                        decoration: BoxDecoration(
                          color: Colors.grey[300], // Placeholder color for video
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "Video Tutorial Here",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          // Removed border
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
          ),
        ),
      ),
    );
  }

  // Function to show the popup menu
  void _showMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 56, 10, 0), // Adjust position to be closer to the dots
      items: [
        PopupMenuItem(
          value: 'edit',
          child: Text(
            'Edit',
            style: TextStyle(
              fontWeight: FontWeight.w800, // Extrabold
              color: Colors.black, // Black color
            ),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text(
            'Delete',
            style: TextStyle(
              fontWeight: FontWeight.w800, // Extrabold
              color: Colors.black, // Black color
            ),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        // Handle edit action
      } else if (value == 'delete') {
        // Handle delete action
      }
    });
  }

  // Helper method to build buttons
  Widget _buildButton(String label, Color color) {
    return ElevatedButton(
      onPressed: () {
        // Handle button action
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }
}
