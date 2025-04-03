import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String? id;
  final String name;
  final String category;
  final String prepTime;
  final String cookTime;
  final int servings;
  final String? imageUrl;
  final String? videoUrl;
  final List<RecipeIngredient> ingredients;
  final List<String> directions;
  final Map<String, dynamic> nutritionalInfo;
  final String userId;
  final DateTime createdAt;

  Recipe({
    this.id,
    required this.name,
    required this.category,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    this.imageUrl,
    this.videoUrl,
    required this.ingredients,
    required this.directions,
    required this.nutritionalInfo,
    required this.userId,
    required this.createdAt,
  });

  factory Recipe.fromMap(Map<String, dynamic> data, String id) {
    return Recipe(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      prepTime: data['prepTime'] ?? '',
      cookTime: data['cookTime'] ?? '',
      servings: data['servings'] ?? 0,
      imageUrl: data['imageUrl'],
      videoUrl: data['videoUrl'],
      ingredients: (data['ingredients'] as List<dynamic>?)
          ?.map((i) => RecipeIngredient.fromMap(i))
          .toList() ?? [],
      directions: (data['directions'] as List<dynamic>?)?.cast<String>() ?? [],
      nutritionalInfo: (data['nutritionalInfo'] as Map<String, dynamic>?) ?? {},
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'ingredients': ingredients.map((i) => i.toMap()).toList(),
      'directions': directions,
      'nutritionalInfo': nutritionalInfo,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class RecipeIngredient {
  final String ingredientId;
  final double amount;
  final String unit;

  RecipeIngredient({
    required this.ingredientId,
    required this.amount,
    required this.unit,
  });

  factory RecipeIngredient.fromMap(Map<String, dynamic> data) {
    return RecipeIngredient(
      ingredientId: data['ingredientId'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      unit: data['unit'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ingredientId': ingredientId,
      'amount': amount,
      'unit': unit,
    };
  }
}