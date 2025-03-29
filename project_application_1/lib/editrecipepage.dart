import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecipePage(),
    );
  }
}

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  RecipePageState createState() => RecipePageState();
}

class RecipePageState extends State {
  int selectedBottomIndex = 0;
  bool _hasVideo = true;
  String? _imagePath = 'assets/TomatoBasilSoup.jpg';
  String _selectedCategory = 'Soups';
  String _recipeName = 'Tomato Basil Soup';
  String _prepTime = '10 minutes';
  String _cookTime = '25 minutes';
  String _totalTime = '35 minutes';
  String _servings = '4';

  final TextEditingController ingredientsController = TextEditingController(
      text: "• 1 tbsp olive oil\n• 1 small onion, chopped\n• 2 cloves garlic, minced\n• 4 cups diced tomatoes (fresh or canned)\n• 2 cups vegetable broth\n• ½ tsp salt\n• ¼ tsp black pepper\n• ½ cup heavy cream (optional)\n• ¼ cup fresh basil, chopped");
  final TextEditingController directionsController = TextEditingController(
      text:
          "1. Heat olive oil in a large pot over medium heat. Add onions and sauté for 3 minutes.\n2. Add garlic and cook for 1 minute.\n3. Stir in diced tomatoes, vegetable broth, salt, and pepper. Bring to a boil.\n4. Reduce heat and simmer for 15 minutes.\n5. Blend the soup until smooth using an immersion blender or countertop blender.\n6. Stir in heavy cream (if using) and fresh basil. Serve hot.");
  final TextEditingController nutritionalController = TextEditingController(
      text: "Calories (kcal): 180\nProtein (g): 3\nCarbs (g): 20\nFat (g): 9");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFDB4F),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Edit Recipe',
            style: TextStyle(
              fontFamily: 'AlbertSans',
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFF8210),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 2,
            color: const Color.fromARGB(255, 234, 113, 15).withOpacity(0.2),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.only(top: 32, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "IMAGE",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFDB4F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          if (_imagePath != null) {
                            _showRemoveImageDialog();
                          } else {
                            debugPrint("Upload image here");
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _imagePath != null
                              ? Image.asset(_imagePath!, fit: BoxFit.cover)
                              : Center(
                                  child: Text(
                                    "Upload a file here. We recommend using high quality files less than 20 MB.",
                                    style: TextStyle(color: Color(0xFF9B9B9B)),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "CATEGORY",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFDB4F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: <String>[
                          'Appetizers',
                          'Beverages',
                          'Breakfast',
                          'Desserts',
                          'Lunch & Dinner',
                          'Salads',
                          'Seafood',
                          'Snacks',
                          'Soups',
                          'Vegetarian'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "NAME",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFDB4F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: _recipeName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _recipeName = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "PREP TIME",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFDB4F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: _prepTime,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _prepTime = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "COOK TIME",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFDB4F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: _cookTime,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _cookTime = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "TOTAL TIME",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFDB4F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: _totalTime,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _totalTime = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "SERVINGS",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFDB4F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: _servings,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: const Color(0xFFFFDB4F)),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _servings = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildSection("INGREDIENTS", ingredientsController),
                      _buildSection("DIRECTIONS", directionsController),
                      _buildSection("NUTRITIONAL INFORMATION (PER SERVING)",
                          nutritionalController),
                      Text(
                        "TUTORIAL",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFDB4F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          if (_hasVideo) {
                            _showRemoveVideoDialog();
                          } else {
                            debugPrint("No video available. Tap to add video.");
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: const Color(0xFFFFDB4F)),
                          ),
                          child: _hasVideo
                              ? const Center(
                                  child: Icon(Icons.videocam,
                                      color: Colors.grey, size: 50),
                                )
                              : const Center(
                                  child: Text(
                                    "Tap to add video",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton("DISCARD", () {}),
                          _buildButton("SAVE", () {}),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildSection(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFDB4F),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFFDB4F)),
          ),
          child: TextField(
            controller: controller,
            maxLines: null,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF8210),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  void _showRemoveVideoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove Video"),
          content: const Text("Are you sure you want to remove the video?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _hasVideo = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove Image"),
          content: const Text("Are you sure you want to remove the image?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _imagePath = null;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
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
        ),
      ),
    );
  }
}