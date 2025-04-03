import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/recipe_model.dart';

class RecipePage extends StatefulWidget {
  // Make the recipe parameter optional to handle navigation from different sources
  final Recipe? recipe;

  const RecipePage({super.key, this.recipe});

  @override
  RecipePageState createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  int selectedBottomIndex = 0;

  // Default values to use if no recipe is provided
  late String title;
  late String category;
  late String prepTime;
  late String cookTime;
  late String totalTime;
  late int servings;
  late List<String> formattedIngredients;
  late List<String> directions;
  late String nutritionalInfo;
  late String? imageUrl;
  late String? videoUrl;
  late String author;
  late String date;
  late double rating;
  late int reviews;

  final Map<String, String> _ingredientNames = {};

  Future<void> _loadIngredientNames() async {
    try {
      final categoriesSnapshot =
          await FirebaseFirestore.instance
              .collection('ingredient_categories')
              .get();

      for (var categoryDoc in categoriesSnapshot.docs) {
        final ingredients = categoryDoc['ingredients'] as List<dynamic>;
        for (var ingredient in ingredients) {
          final ingredientId = '${categoryDoc.id}_${ingredient['name']}';
          _ingredientNames[ingredientId] = ingredient['name'] as String;
        }
      }

      // Refresh the UI if we have a recipe
      if (widget.recipe != null && mounted) {
        setState(() {
          formattedIngredients = _formatIngredients(widget.recipe!.ingredients);
        });
      }
    } catch (e) {
      print('Error loading ingredients: $e');
    }
  }

  List<String> _formatIngredients(List<RecipeIngredient> ingredients) {
    return ingredients.map((ingredient) {
      final name =
          _ingredientNames[ingredient.ingredientId] ?? 'Unknown ingredient';
      return '${ingredient.amount} ${ingredient.unit} $name';
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _initializeRecipeData();
    _loadIngredientNames();
  }

  void _initializeRecipeData() {
    if (widget.recipe != null) {
      // If a recipe was provided, use its data
      final recipe = widget.recipe!;
      title = recipe.name;
      category = recipe.category;
      prepTime = recipe.prepTime;
      cookTime = recipe.cookTime;

      // Calculate total time (could be more complex in a real app)
      // This assumes prepTime and cookTime are in format "XX minutes"
      try {
        final prep = int.parse(prepTime.split(' ')[0]);
        final cook = int.parse(cookTime.split(' ')[0]);
        totalTime = '${prep + cook} minutes';
      } catch (e) {
        totalTime = 'See prep and cook time';
      }

      servings = recipe.servings;

      formattedIngredients = _formatIngredients(recipe.ingredients);

      directions = recipe.directions;

      // Format nutritional info
      final nutrients = recipe.nutritionalInfo;
      nutritionalInfo = nutrients.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join(' | ');

      imageUrl = recipe.imageUrl;
      videoUrl = recipe.videoUrl;

      author = recipe.author;
      date =
          "${recipe.createdAt.month}/${recipe.createdAt.day}/${recipe.createdAt.year}";
      rating = 4.5;
      reviews = 10;
    } else {
      title = "Chocolate Chip Cookies";
      category = "Dessert";
      prepTime = "15 minutes";
      cookTime = "12 minutes";
      totalTime = "27 minutes";
      servings = 24;
      formattedIngredients = [
        "1 cup unsalted butter, softened",
        "¾ cup brown sugar",
        "¾ cup white sugar",
        "2 eggs",
        "2 tsp vanilla extract",
        "2 ½ cups all-purpose flour",
        "1 tsp baking soda",
        "½ tsp salt",
        "2 cups chocolate chips",
      ];
      directions = [
        "Preheat oven to 350°F (175°C). Line a baking sheet with parchment paper.",
        "In a bowl, cream together butter, brown sugar, and white sugar.",
        "Add eggs and vanilla, mixing until smooth.",
        "Sift in flour, baking soda, and salt. Stir to combine.",
        "Fold in chocolate chips. Drop spoonful of dough onto the baking sheet.",
        "Bake for 10–12 minutes until golden brown. Let cool before serving.",
      ];
      nutritionalInfo =
          "Calories: 160kcal | Protein: 2g | Carbs: 22g | Fat: 8g";
      imageUrl = null;
      videoUrl = null;
      author = "Javindu Gunasekara";
      date = "July 18th, 2024";
      rating = 3.2;
      reviews = 23;
    }
  }

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFFF8210)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Color(0xFFFF8210),
            ), // Horizontal three-dot icon
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
            color: const Color.fromARGB(
              255,
              234,
              113,
              15,
            ).withOpacity(0.2), // Border color
          ),
          Expanded(
            child: SingleChildScrollView(
              // Enable scrolling
              child: Center(
                child: Container(
                  width:
                      MediaQuery.of(context).size.width *
                      0.9, // Increased width with margin
                  decoration: BoxDecoration(
                    color: Colors.white, // Box color
                    borderRadius: BorderRadius.circular(20), // Curved corners
                  ),
                  padding: const EdgeInsets.all(16), // Padding inside the box
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🔵 Recipe Image
                      imageUrl != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: Image.network(
                              imageUrl!,
                              width: 160,
                              height: 160,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const CircleAvatar(
                                        radius: 80,
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 50,
                                        ),
                                      ),
                            ),
                          )
                          : CircleAvatar(
                            radius: 80,
                            backgroundImage: AssetImage('assets/cookies.png'),
                            onBackgroundImageError:
                                (_, __) =>
                                    const Icon(Icons.broken_image, size: 50),
                          ),
                      const SizedBox(height: 16),

                      // 🏷 Recipe Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 46, // Increased font size
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // ⭐ Rating and Review Count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$rating ",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Display stars based on rating
                          ...List.generate(5, (index) {
                            return Icon(
                              index < rating.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.orange,
                              size: 20,
                            );
                          }),
                          Text(" ($reviews)"),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // ✍ Author and Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            author,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(date),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // 🏷 Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8210).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: Color(0xFFFF8210),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 🔘 SAVE & RATE Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildButton("SAVE", Colors.orange),
                          const SizedBox(width: 16),
                          _buildButton(
                            "RATE",
                            const Color(0xFF0EDDD2),
                          ), // Rate button color updated
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "🍽 Prep time: $prepTime",
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF9B9B9B),
                              ),
                            ),
                            Text(
                              "🍽 Cook time: $cookTime",
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF9B9B9B),
                              ),
                            ),
                            Text(
                              "🍽 Total time: $totalTime",
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF9B9B9B),
                              ),
                            ),
                            Text(
                              "🍽 Servings: $servings",
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF9B9B9B),
                              ),
                            ),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0EDDD2),
                          ),
                        ),
                      ),
                      ...formattedIngredients
                          .map(
                            (ingredient) => Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "• $ingredient",
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                          .toList(),
                      const SizedBox(height: 16),

                      // 📜 Directions Section
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Directions",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0EDDD2),
                          ),
                        ),
                      ),
                      ...List.generate(
                        directions.length,
                        (index) => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${index + 1}. ${directions[index]}",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 📊 Nutritional Information Section
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Nutritional Information (per serving)",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0EDDD2),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          nutritionalInfo,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 📹 Tutorial Section
                      if (videoUrl != null) ...[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Tutorial",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0EDDD2),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 200, // Height for video box
                          decoration: BoxDecoration(
                            color:
                                Colors.grey[300], // Placeholder color for video
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            // Replace this with a video player widget that uses videoUrl
                            child: Icon(
                              Icons.play_circle_fill,
                              size: 60,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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
                        margin: const EdgeInsets.only(top: 4),
                        height: 2,
                        width: 24,
                        color: const Color(0xFFFFDB4F),
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
                        margin: const EdgeInsets.only(top: 4),
                        height: 2,
                        width: 24,
                        color: const Color(0xFFFFDB4F),
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
                        margin: const EdgeInsets.only(top: 4),
                        height: 2,
                        width: 24,
                        color: const Color(0xFFFFDB4F),
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
      position: const RelativeRect.fromLTRB(
        100,
        56,
        10,
        0,
      ), // Adjust position to be closer to the dots
      items: [
        const PopupMenuItem(
          value: 'edit',
          child: Text(
            'Edit',
            style: TextStyle(
              fontWeight: FontWeight.w800, // Extrabold
              color: Colors.black, // Black color
            ),
          ),
        ),
        const PopupMenuItem(
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
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
