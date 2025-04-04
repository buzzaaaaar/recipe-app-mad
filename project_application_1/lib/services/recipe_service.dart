import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all recipes
  Future<List<Recipe>> getAllRecipes() async {
    final snapshot = await _firestore.collection('recipes').get();
    return snapshot.docs
        .map((doc) => Recipe.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Fetch recipes filtered by selected ingredients
  Future<List<Recipe>> getRecipesWithIngredients(
    Set<String> ingredientIds,
  ) async {
    if (ingredientIds.isEmpty) {
      return getAllRecipes();
    }

    final snapshot = await _firestore.collection('recipes').get();
    final recipes =
        snapshot.docs.map((doc) => Recipe.fromMap(doc.data(), doc.id)).toList();

    final recipesWithAvailability =
        recipes.map((recipe) {
          final recipeIngredientIds =
              recipe.ingredients.map((i) => i.ingredientId).toSet();

          final matchedIngredients = recipeIngredientIds.intersection(
            ingredientIds,
          );
          final availabilityPercentage =
              recipeIngredientIds.isEmpty
                  ? 0.0
                  : matchedIngredients.length / recipeIngredientIds.length;

          final canMake =
              recipeIngredientIds.isNotEmpty &&
              recipeIngredientIds.every((id) => ingredientIds.contains(id));

          return {
            'recipe': recipe,
            'canMake': canMake,
            'availabilityPercentage': availabilityPercentage,
            'missingIngredients':
                recipeIngredientIds.difference(ingredientIds).length,
          };
        }).toList();

    recipesWithAvailability.sort((a, b) {
      if (a['canMake'] != b['canMake']) {
        return a['canMake'] != null ? -1 : 1;
      }
      return (b['availabilityPercentage'] as double).compareTo(
        a['availabilityPercentage'] as double,
      );
    });

    return recipesWithAvailability
        .map((item) => item['recipe'] as Recipe)
        .toList();
  }

  // Fetch ingredients from categories
  Future<Map<String, List<Map<String, dynamic>>>>
  getIngredientsGroupedByCategory() async {
    final categoriesSnapshot =
        await _firestore.collection('ingredient_categories').get();
    final result = <String, List<Map<String, dynamic>>>{};

    for (var doc in categoriesSnapshot.docs) {
      final categoryData = doc.data();
      final categoryName = categoryData['name'] as String;
      final ingredients =
          (categoryData['ingredients'] as List<dynamic>).map((ingredient) {
            return {
              'id': '${doc.id}_${ingredient['name']}',
              'name': ingredient['name'],
              'selected': false,
            };
          }).toList();

      result[categoryName] = ingredients;
    }

    return result;
  }

  // NEW 🔥: Toggle save or unsave a recipe
  Future<void> toggleSaveRecipe({
    required String userId,
    required String recipeId,
    required bool isAlreadySaved,
  }) async {
    final userRef = _firestore.collection('users').doc(userId);

    await userRef.update({
      'savedRecipes':
          isAlreadySaved
              ? FieldValue.arrayRemove([recipeId])
              : FieldValue.arrayUnion([recipeId]),
    });
  }

  // NEW 💡: Get saved recipe IDs for a user
  Future<List<String>> getSavedRecipeIds(String userId) async {
    final snapshot = await _firestore.collection('users').doc(userId).get();
    final data = snapshot.data();
    if (data != null && data.containsKey('savedRecipes')) {
      return List<String>.from(data['savedRecipes']);
    }
    return [];
  }
}
