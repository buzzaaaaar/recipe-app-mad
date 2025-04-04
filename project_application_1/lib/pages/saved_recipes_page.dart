import 'package:flutter/material.dart';
import '../services/recipe_service.dart';
import '../models/recipe_model.dart';
import '../Components/recipeCard2.dart';
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
      recipeId: recipe.id ?? '',
      isAlreadySaved: isAlreadySaved,
    );

    setState(() {
      isAlreadySaved ? savedIds.remove(recipe.id) : savedIds.add(recipe.id!);
      savedRecipes =
          savedRecipes.where((r) => savedIds.contains(r.id)).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAlreadySaved ? 'Removed from saved 💔' : 'Saved to your recipes 💾',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.orange.shade400,
      ),
    );
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: RecipeCard2(
                      image: recipe.imageUrl ?? 'images/default_recipe.jpg',
                      title: recipe.name,
                      rating: "4.5", // Replace with real rating if needed
                      reviews: "10",
                      isSaved: savedIds.contains(recipe.id),
                      onToggleSave: () => _toggleSave(recipe),
                    ),
                  );
                },
              ),
    );
  }
}
