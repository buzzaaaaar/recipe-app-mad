import 'package:flutter/material.dart';
import '../widgets/recipe_card.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';

class DiscoverPage extends StatefulWidget {
  final Set<String> selectedIngredientIds;

  const DiscoverPage({Key? key, required this.selectedIngredientIds})
    : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Set<String> selectedCategories = Set();
  List<Recipe> allRecipes = [];
  List<Recipe> filteredRecipes = [];
  bool isLoading = true;
  String errorMessage = '';

  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  @override
  void didUpdateWidget(DiscoverPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the selected ingredients changed, update recipes
    if (oldWidget.selectedIngredientIds != widget.selectedIngredientIds) {
      _filterRecipes();
    }
  }

  Future<void> _loadRecipes() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      // Load recipes filtered by selected ingredients
      allRecipes = await _recipeService.getRecipesWithIngredients(
        widget.selectedIngredientIds,
      );

      // Apply category filters if any
      _filterRecipes();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load recipes: $e';
      });
    }
  }

  void _filterRecipes() {
    if (selectedCategories.isEmpty) {
      // No category filters, just filter by ingredients
      filteredRecipes = allRecipes;
    } else {
      // Filter by both ingredients and categories
      filteredRecipes =
          allRecipes.where((recipe) {
            return selectedCategories.contains(recipe.category);
          }).toList();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Count recipes that can be made
    final int recipeCount =
        filteredRecipes.where((recipe) {
          final recipeIngredientIds =
              recipe.ingredients.map((i) => i.ingredientId).toSet();
          return recipeIngredientIds.every(
            (id) => widget.selectedIngredientIds.contains(id),
          );
        }).length;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                isLoading
                    ? "Loading recipes..."
                    : "You can make $recipeCount recipes.",
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildCategoryFilters(),
            SizedBox(height: 16),

            // Error message
            if (errorMessage.isNotEmpty)
              Center(
                child: Text(errorMessage, style: TextStyle(color: Colors.red)),
              ),

            // Loading indicator
            if (isLoading) Center(child: CircularProgressIndicator()),

            // No recipes message
            if (!isLoading && filteredRecipes.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "No recipes found. Try selecting different ingredients or categories.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
              ),

            // Recipe list
            if (!isLoading && filteredRecipes.isNotEmpty) _buildRecipeList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final categories = ["Dessert", "Breakfast", "Lunch", "Dinner", "Snack"];

    return Wrap(
      spacing: 8.0,
      children:
          categories.map((category) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  if (selectedCategories.contains(category)) {
                    selectedCategories.remove(category);
                  } else {
                    selectedCategories.add(category);
                  }
                  _filterRecipes();
                });
              },
              child: Text(category),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedCategories.contains(category)
                        ? Color(0xFFFF8210)
                        : Colors.white,
                foregroundColor:
                    selectedCategories.contains(category)
                        ? Colors.white
                        : Color(0xFFFF8210),
                side: BorderSide(color: Color(0xFFFF8210)),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildRecipeList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = filteredRecipes[index];

        // Check if user can make this recipe with selected ingredients
        final recipeIngredientIds =
            recipe.ingredients.map((i) => i.ingredientId).toSet();
        final canMake = recipeIngredientIds.every(
          (id) => widget.selectedIngredientIds.contains(id),
        );

        // Calculate how many ingredients are missing
        final missingIngredients =
            recipeIngredientIds
                .where((id) => !widget.selectedIngredientIds.contains(id))
                .length;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: RecipeCard(
            imageUrl: recipe.imageUrl ?? "assets/placeholder-recipe.png",
            title: recipe.name,
            author:
                recipe
                    .author, // You might want to add author name to Recipe model
            rating: 4.0, // You might want to add rating to Recipe model
            reviews: 12, // You might want to add reviews to Recipe model
            canMake: canMake,
            missingIngredients: missingIngredients,
            recipe: recipe, // Pass the full recipe object for navigation
          ),
        );
      },
    );
  }
}
