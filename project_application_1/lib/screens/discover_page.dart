import 'package:flutter/material.dart';
import '../widgets/recipe_card.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiscoverPage extends StatefulWidget {
  final Set<String> selectedIngredientIds;

  const DiscoverPage({Key? key, required this.selectedIngredientIds})
    : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Set<String> selectedCategories = {};
  List<Recipe> allRecipes = [];
  List<Recipe> filteredRecipes = [];
  List<String> savedRecipeIds = [];

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

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final ingredientsRecipes = await _recipeService.getRecipesWithIngredients(
        widget.selectedIngredientIds,
      );
      final savedIds = await _recipeService.getSavedRecipeIds(userId);

      setState(() {
        allRecipes = ingredientsRecipes;
        savedRecipeIds = savedIds;
        _filterRecipes();
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
      filteredRecipes = allRecipes;
    } else {
      filteredRecipes =
          allRecipes.where((recipe) {
            return selectedCategories.contains(recipe.category);
          }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 16),
            const Text(
              "Category",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCategoryFilters(),
            const SizedBox(height: 16),

            if (errorMessage.isNotEmpty)
              Center(
                child: Text(errorMessage, style: TextStyle(color: Colors.red)),
              ),

            if (isLoading) const Center(child: CircularProgressIndicator()),

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
            final isSelected = selectedCategories.contains(category);
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  isSelected
                      ? selectedCategories.remove(category)
                      : selectedCategories.add(category);
                  _filterRecipes();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isSelected ? const Color(0xFFFF8210) : Colors.white,
                foregroundColor:
                    isSelected ? Colors.white : const Color(0xFFFF8210),
                side: const BorderSide(color: Color(0xFFFF8210)),
              ),
              child: Text(category),
            );
          }).toList(),
    );
  }

  Widget _buildRecipeList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = filteredRecipes[index];

        final recipeIngredientIds =
            recipe.ingredients.map((i) => i.ingredientId).toSet();
        final canMake = recipeIngredientIds.every(
          (id) => widget.selectedIngredientIds.contains(id),
        );
        final missingIngredients =
            recipeIngredientIds.difference(widget.selectedIngredientIds).length;

        final isSaved = savedRecipeIds.contains(recipe.id);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: RecipeCard(
            imageUrl: recipe.imageUrl ?? "assets/placeholder-recipe.png",
            title: recipe.name,
            author: recipe.author,
            rating: 4.0,
            reviews: 12,
            canMake: canMake,
            missingIngredients: missingIngredients,
            recipe: recipe,
            isSaved: isSaved,
            onToggleSave: () async {
              final userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId == null) return;

              await _recipeService.toggleSaveRecipe(
                userId: userId,
                recipeId: recipe.id!,
                isAlreadySaved: isSaved,
              );

              setState(() {
                isSaved
                    ? savedRecipeIds.remove(recipe.id)
                    : savedRecipeIds.add(recipe.id!);
              });
            },
          ),
        );
      },
    );
  }
}
