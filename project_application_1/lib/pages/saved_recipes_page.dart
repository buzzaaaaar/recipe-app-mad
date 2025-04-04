import 'package:flutter/material.dart';
import '../services/recipe_service.dart';
import '../models/recipe_model.dart';
import '../widgets/recipe_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SavedRecipesPage extends StatefulWidget {
  const SavedRecipesPage({super.key});

  @override
  State<SavedRecipesPage> createState() => _SavedRecipesPageState();
}

class _SavedRecipesPageState extends State<SavedRecipesPage> {
  final RecipeService _recipeService = RecipeService();
  List<Recipe> savedRecipes = [];
  List<String> savedIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedRecipes();
  }

  Future<void> _loadSavedRecipes() async {
    setState(() => isLoading = true);

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final ids = await _recipeService.getSavedRecipeIds(userId);
    final allRecipes = await _recipeService.getAllRecipes();

    setState(() {
      savedIds = ids;
      savedRecipes =
          allRecipes.where((recipe) => ids.contains(recipe.id)).toList();
      isLoading = false;
    });
  }

  void _toggleSave(Recipe recipe) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final isAlreadySaved = savedIds.contains(recipe.id);

    await _recipeService.toggleSaveRecipe(
      userId: userId,
      recipeId: recipe.id,
      isAlreadySaved: isAlreadySaved,
    );

    setState(() {
      isAlreadySaved ? savedIds.remove(recipe.id) : savedIds.add(recipe.id);

      savedRecipes =
          savedRecipes.where((r) => savedIds.contains(r.id)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Recipes"),
        backgroundColor: const Color(0xFFFFDB4F),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : savedRecipes.isEmpty
              ? const Center(child: Text("No saved recipes yet 💔"))
              : ListView.builder(
                itemCount: savedRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = savedRecipes[index];
                  return RecipeCard(
                    imageUrl: recipe.imageUrl,
                    title: recipe.title,
                    author: recipe.author,
                    rating: recipe.rating,
                    reviews: recipe.reviews,
                    canMake: true, // or calculate if needed
                    missingIngredients: 0,
                    recipe: recipe,
                    isSaved: savedIds.contains(recipe.id),
                    onToggleSave: () => _toggleSave(recipe),
                  );
                },
              ),
    );
  }
}
