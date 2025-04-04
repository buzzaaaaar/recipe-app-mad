import 'package:flutter/material.dart';
import 'package:project_application_1/pages/profilePage.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import 'discover_page.dart';
import '../services/recipe_service.dart';
import '../screens/explore_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedBottomIndex = 0;
  int selectedTopIndex = 0;
  bool isLoading = true;
  String errorMessage = '';

  // Track selected ingredients across all categories
  final Set<String> selectedIngredientIds = {};

  // For UI organization
  List<Category> categories = [];
  Map<String, List<Map<String, dynamic>>> ingredientsByCategory = {};

  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      // Load ingredients grouped by category
      ingredientsByCategory =
          await _recipeService.getIngredientsGroupedByCategory();

      // Create Category objects for UI
      categories =
          ingredientsByCategory.entries.map((entry) {
            final categoryName = entry.key;
            final ingredients = entry.value;

            // Count selected ingredients in this category
            final selectedCount =
                ingredients
                    .where(
                      (ingredient) =>
                          selectedIngredientIds.contains(ingredient['id']),
                    )
                    .length;

            return Category(
              categoryName,
              selectedCount,
              ingredients.length,
              _getCategoryIconPath(categoryName),
            );
          }).toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load ingredients: $e';
      });
    }
  }

  String _getCategoryIconPath(String categoryName) {
    // Map category names to icon paths
    switch (categoryName.toLowerCase()) {
      case 'vegetables':
        return 'assets/icons/VegetablesIcon.png';
      case 'fruits':
        return 'assets/icons/FruitsIcon.png';
      case 'proteins':
        return 'assets/icons/ProteinsIcon.png';
      case 'grains & starches':
        return 'assets/icons/GrainsAndStarchesIcon.png';
      default:
        return 'assets/icons/VegetablesIcon.png'; // Default icon
    }
  }

  // Toggle selection of an ingredient
  void toggleIngredientSelection(String ingredientId, String categoryName) {
    setState(() {
      if (selectedIngredientIds.contains(ingredientId)) {
        selectedIngredientIds.remove(ingredientId);
      } else {
        selectedIngredientIds.add(ingredientId);
      }

      // Update the Category object's selected count
      for (var i = 0; i < categories.length; i++) {
        if (categories[i].name == categoryName) {
          final selectedCount =
              ingredientsByCategory[categoryName]!
                  .where(
                    (ingredient) =>
                        selectedIngredientIds.contains(ingredient['id']),
                  )
                  .length;

          categories[i] = Category(
            categoryName,
            selectedCount,
            categories[i].total,
            categories[i].iconPath,
          );
          break;
        }
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ExplorePage()),
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
              ? DiscoverPage(selectedIngredientIds: selectedIngredientIds)
              : _buildPantryPage(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          child: BottomNavigationBar(
            currentIndex: selectedBottomIndex,
            onTap: _onItemTapped,
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

  Widget _buildPantryPage() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(errorMessage, style: TextStyle(color: Colors.red)),
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
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

                  // Show count of recipes available with selected ingredients
                  if (selectedIngredientIds.isNotEmpty)
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF8210).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          "You've selected ${selectedIngredientIds.length} ingredients",
                          style: TextStyle(
                            fontFamily: 'AlbertSans',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF8210),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 16),

                  // Categories list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        category: categories[index],
                        onExpand: () {
                          // Show ingredients dialog for this category
                          _showIngredientsDialog(categories[index].name);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _updateCategorySelectionCount(String categoryName) {
    for (var i = 0; i < categories.length; i++) {
      if (categories[i].name == categoryName) {
        final selectedCount =
            ingredientsByCategory[categoryName]!
                .where(
                  (ingredient) =>
                      selectedIngredientIds.contains(ingredient['id']),
                )
                .length;

        categories[i] = Category(
          categoryName,
          selectedCount,
          categories[i].total,
          categories[i].iconPath,
        );
        break;
      }
    }
  }

  void _showIngredientsDialog(String categoryName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final ingredients = ingredientsByCategory[categoryName] ?? [];

            return AlertDialog(
              title: Text(
                categoryName,
                style: TextStyle(
                  fontFamily: 'AlbertSans',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (ingredients
                        .where((i) => selectedIngredientIds.contains(i['id']))
                        .isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFF8210).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${ingredients.where((i) => selectedIngredientIds.contains(i['id'])).length} selected",
                            style: TextStyle(
                              fontFamily: 'AlbertSans',
                              color: Color(0xFFFF8210),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: ingredients.length,
                        itemBuilder: (context, index) {
                          final ingredient = ingredients[index];
                          final isSelected = selectedIngredientIds.contains(
                            ingredient['id'],
                          );

                          return InkWell(
                            onTap: () {
                              setDialogState(() {
                                if (isSelected) {
                                  selectedIngredientIds.remove(
                                    ingredient['id'],
                                  );
                                } else {
                                  selectedIngredientIds.add(ingredient['id']);
                                }
                                _updateCategorySelectionCount(categoryName);
                              });

                              // Also update main state to reflect changes in other UI parts
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Color(0xFFFF8210)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Color(0xFFFF8210)
                                          : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      ingredient['name'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'AlbertSans',
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black87,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Color(0xFFFF8210),
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Color(0xFFFF8210),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
