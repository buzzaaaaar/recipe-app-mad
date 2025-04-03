import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new recipe
  Future<String> addRecipe(Recipe recipe) async {
    try {
      final docRef = await _firestore.collection('recipes').add(recipe.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add recipe: $e');
    }
  }

  // Get all ingredients
  Future<List<Map<String, dynamic>>> getAllIngredients() async {
    try {
      final snapshot = await _firestore.collection('ingredients').get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'unitTypes': List<String>.from(doc['unitTypes']),
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to get ingredients: $e');
    }
  }

  // Add sample ingredients to Firestore (run once)
  Future<void> addSampleIngredients() async {
    const ingredients = [
      {
        'name': 'Sugar',
        'unitTypes': ['cup', 'tablespoon', 'teaspoon', 'gram'],
        'category': 'Pantry'
      },
      {
        'name': 'Flour',
        'unitTypes': ['cup', 'gram', 'ounce'],
        'category': 'Pantry'
      },
      {
        'name': 'Milk',
        'unitTypes': ['cup', 'ml', 'tablespoon'],
        'category': 'Dairy'
      },
      // Add more ingredients as needed
    ];

    final batch = _firestore.batch();
    final ingredientsRef = _firestore.collection('ingredients');

    for (var ingredient in ingredients) {
      batch.set(ingredientsRef.doc(), ingredient);
    }

    await batch.commit();
  }
}