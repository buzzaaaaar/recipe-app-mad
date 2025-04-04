import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CreateRecipePage(),
    );
  }
}

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  CreateRecipePageState createState() => CreateRecipePageState();
}

class CreateRecipePageState extends State<CreateRecipePage> {
  int selectedBottomIndex = 0;
  // Removing the unused _hasVideo field or utilizing it
  File? _imageFile;
  File? _videoFile;
  String? _selectedCategory;
  String _recipeName = '';
  String _prepTime = '';
  String _cookTime = '';
  String _totalTime = '';
  String _servings = '';
  String _errorMessage = '';
  bool _isLoading = false;

  // Ingredients management
  final List<Map<String, dynamic>> _allIngredients = [];
  final List<Map<String, dynamic>> _ingredientCategories = [];
  final List<Map<String, dynamic>> _selectedIngredients = [];
  Map<String, dynamic>? _currentIngredient;
  double _currentAmount = 0;
  String? _currentUnit;

  final TextEditingController directionsController = TextEditingController();
  final TextEditingController nutritionalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print('Loading ingredients from Firebase...');
    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    try {
      final categoriesSnapshot =
          await FirebaseFirestore.instance
              .collection('ingredient_categories')
              .get();

      final categories =
          categoriesSnapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList();

      setState(() {
        _ingredientCategories.clear();
        _ingredientCategories.addAll(categories);

        // Extract all ingredients from categories to populate _allIngredients
        _allIngredients.clear();
        for (var category in _ingredientCategories) {
          final categoryIngredients = category['ingredients'] as List<dynamic>;
          for (var ingredient in categoryIngredients) {
            _allIngredients.add({
              'id':
                  '${category['id']}_${ingredient['name']}', // Create a unique ID
              'name': ingredient['name'],
              'unitTypes': ingredient['unitTypes'],
              'category': category['name'],
            });
          }
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load ingredients: $e';
      });
      print('Error loading ingredients: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadFile(File file, String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to upload file: $e';
      });
      return null;
    }
  }

  // lib/createrecipepage.dart
  Future<void> _postRecipe() async {
    if (!_formKey.currentState!.validate() || _selectedIngredients.isEmpty) {
      setState(() {
        _errorMessage =
            _selectedIngredients.isEmpty
                ? 'Please add at least one ingredient'
                : 'Please fill in all required fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = 'User not authenticated';
          _isLoading = false;
        });
        return;
      }

      // Get user data from Firestore
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (!userDoc.exists) {
        setState(() {
          _errorMessage = 'User data not found';
          _isLoading = false;
        });
        return;
      }

      final username = userDoc.data()?['username'] ?? 'Unknown';

      // Upload image and video if they exist
      String? imageUrl;
      String? videoUrl;

      if (_imageFile != null) {
        imageUrl = await _uploadFile(
          _imageFile!,
          'recipes/images/${DateTime.now().millisecondsSinceEpoch}',
        );
      }

      if (_videoFile != null) {
        videoUrl = await _uploadFile(
          _videoFile!,
          'recipes/videos/${DateTime.now().millisecondsSinceEpoch}',
        );
      }

      // Create recipe data
      final recipeData = {
        'name': _recipeName,
        'category': _selectedCategory,
        'prepTime': _prepTime,
        'cookTime': _cookTime,
        'totalTime': _totalTime,
        'servings': int.tryParse(_servings) ?? 0,
        'ingredients':
            _selectedIngredients.map((ingredient) {
              return {
                'ingredientId': ingredient['id'],
                'amount': ingredient['amount'],
                'unit': ingredient['unit'],
              };
            }).toList(),
        'directions': directionsController.text.split('\n'),
        'nutritionalInfo': _parseNutritionalInfo(nutritionalController.text),
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'userId': user.uid,
        'author': username, // Add the username as author
        'createdAt': Timestamp.now(),
      };

      // Save to Firestore
      await FirebaseFirestore.instance.collection('recipes').add(recipeData);

      // Navigate away or show success message
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe posted successfully!')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to post recipe: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> _parseNutritionalInfo(String text) {
    final lines = text.split('\n');
    final result = <String, dynamic>{};
    for (var line in lines) {
      final parts = line.split(':');
      if (parts.length == 2) {
        result[parts[0].trim()] = parts[1].trim();
      }
    }
    return result;
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "INGREDIENTS",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFDB4F),
          ),
        ),
        const SizedBox(height: 8),

        // Selected ingredients list
        if (_selectedIngredients.isNotEmpty)
          Column(
            children:
                _selectedIngredients.map((ingredient) {
                  return ListTile(
                    title: Text(ingredient['name']),
                    subtitle: Text(
                      '${ingredient['amount']} ${ingredient['unit']}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _selectedIngredients.remove(ingredient);
                        });
                      },
                    ),
                  );
                }).toList(),
          ),

        // Add ingredient controls - Make sure this is wrapped properly
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                // Ingredient dropdown
                Container(
                  width: 150, // Reduced width
                  child: DropdownButtonFormField<Map<String, dynamic>>(
                    value: _currentIngredient,
                    items:
                        _allIngredients
                            .map<DropdownMenuItem<Map<String, dynamic>>>((
                              ingredient,
                            ) {
                              return DropdownMenuItem<Map<String, dynamic>>(
                                value: ingredient,
                                child: Text(
                                  '${ingredient['name']}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            })
                            .toList(),
                    onChanged: (Map<String, dynamic>? value) {
                      setState(() {
                        _currentIngredient = value;
                        if (value != null &&
                            value['unitTypes'] is List &&
                            (value['unitTypes'] as List).isNotEmpty) {
                          _currentUnit =
                              (value['unitTypes'] as List<dynamic>).first
                                  .toString();
                        } else {
                          _currentUnit = null;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Ingredient',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: const Color(0xFFFFDB4F)),
                      ),
                    ),
                    isExpanded: true, // This helps with overflow
                  ),
                ),

                const SizedBox(width: 8),

                // Amount field
                Container(
                  width: 80, // Reduced width
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: const Color(0xFFFFDB4F)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _currentAmount = double.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 8),

                // Unit dropdown
                Container(
                  width: 80, // Reduced width
                  child: DropdownButtonFormField<String>(
                    value: _currentUnit,
                    items:
                        (_currentIngredient?['unitTypes'] as List<dynamic>? ??
                                [])
                            .map<DropdownMenuItem<String>>((unit) {
                              return DropdownMenuItem<String>(
                                value: unit as String,
                                child: Text(unit),
                              );
                            })
                            .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _currentUnit = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: const Color(0xFFFFDB4F)),
                      ),
                    ),
                    isExpanded: true, // This helps with overflow
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            if (_currentIngredient != null &&
                _currentUnit != null &&
                _currentAmount > 0) {
              setState(() {
                _selectedIngredients.add({
                  'id': _currentIngredient!['id'],
                  'name': _currentIngredient!['name'],
                  'amount': _currentAmount,
                  'unit': _currentUnit!,
                });
                _currentIngredient = null;
                _currentAmount = 0;
                _currentUnit = null;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF8210),
          ),
          child: const Text(
            'Add Ingredient',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFDB4F),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Create Recipe',
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
            color: const Color.fromARGB(
              255,
              234,
              113,
              15,
            ).withOpacity(0.2), // Fixed: Changed withValues to withOpacity
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Section
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
                          onTap: _pickImage,
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:
                                _imageFile != null
                                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                                    : const Center(
                                      child: Text(
                                        "Tap to upload image (less than 20MB)",
                                        style: TextStyle(
                                          color: Color(0xFF9B9B9B),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Category Section
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                          items:
                              <String>[
                                'Breakfast',
                                'Desserts',
                                'Lunch & Dinner',
                                'Snacks',
                                'Vegetarian',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: const Color(0xFFFFDB4F),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Recipe Name
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: const Color(0xFFFFDB4F),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter recipe name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _recipeName = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Times and Servings
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: const Color(0xFFFFDB4F),
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _prepTime = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: const Color(0xFFFFDB4F),
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _cookTime = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: const Color(0xFFFFDB4F),
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _totalTime = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: const Color(0xFFFFDB4F),
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'Enter a number';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _servings = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Ingredients Section
                        _buildIngredientsSection(),

                        // Directions Section
                        Text(
                          "DIRECTIONS",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFFDB4F),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: directionsController,
                          maxLines: 5,
                          minLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: const Color(0xFFFFDB4F),
                              ),
                            ),
                            hintText: 'Enter each step on a new line',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter directions';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Nutritional Info
                        Text(
                          "NUTRITIONAL INFO",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFFDB4F),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: nutritionalController,
                          maxLines: 5,
                          minLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: const Color(0xFFFFDB4F),
                              ),
                            ),
                            hintText:
                                'Enter each item on a new line (e.g., Calories: 250)',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Video Tutorial
                        Text(
                          "TUTORIAL VIDEO (OPTIONAL)",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFFDB4F),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickVideo,
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFFFDB4F),
                              ),
                            ),
                            child:
                                _videoFile != null
                                    ? const Center(
                                      child: Icon(
                                        Icons.videocam,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    )
                                    : const Center(
                                      child: Text(
                                        "Tap to upload video",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Error Message
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),

                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildButton("DISCARD", () {
                              Navigator.pop(context);
                            }),
                            _buildButton(
                              "POST",
                              _postRecipe,
                              isLoading: _isLoading,
                            ),
                          ],
                        ),
                      ],
                    ),
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

  Widget _buildButton(
    String text,
    VoidCallback onPressed, {
    bool isLoading = false,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF8210),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child:
          isLoading
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
              : Text(
                text,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: selectedBottomIndex,
      onTap: (index) {
        setState(() {
          selectedBottomIndex = index;
        });
      },
      selectedItemColor: const Color(0xFFFF8210),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
