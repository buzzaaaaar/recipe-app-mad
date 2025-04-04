import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/recipe_model.dart';

class EditRecipePage extends StatefulWidget {
  final Recipe recipe;

  const EditRecipePage({super.key, required this.recipe});

  @override
  EditRecipePageState createState() => EditRecipePageState();
}

class EditRecipePageState extends State<EditRecipePage> {
  int selectedBottomIndex = 0;
  late Recipe _editedRecipe;
  File? _imageFile;
  File? _videoFile;
  bool _isLoading = false;
  String _errorMessage = '';

  // Ingredients management
  final List<Map<String, dynamic>> _allIngredients = [];
  final List<Map<String, dynamic>> _ingredientCategories = [];
  final List<Map<String, dynamic>> _selectedIngredients = [];
  Map<String, dynamic>? _currentIngredient;
  double _currentAmount = 0;
  String? _currentUnit;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _directionsController = TextEditingController();
  final TextEditingController _nutritionalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editedRecipe = widget.recipe;
    _initializeSelectedIngredients();
    _loadIngredients();
    _initializeControllers();
  }

  void _initializeSelectedIngredients() {
    _selectedIngredients.clear();
    for (var ing in _editedRecipe.ingredients) {
      // Find the full ingredient details from _allIngredients
      var fullIngredient = _allIngredients.firstWhere(
        (i) => i['id'] == ing.ingredientId,
        orElse:
            () => {
              'id': ing.ingredientId,
              'name': ing.name,
              'unitTypes': [ing.unit], // Default unit types
              'category': 'Unknown',
            },
      );

      _selectedIngredients.add({
        'id': ing.ingredientId,
        'name': fullIngredient['name'] ?? ing.name,
        'amount': ing.amount,
        'unit': ing.unit,
        'unitTypes': fullIngredient['unitTypes'],
      });
    }
  }

  void _initializeControllers() {
    _directionsController.text = _editedRecipe.directions.join('\n');
    _nutritionalController.text = _editedRecipe.nutritionalInfo.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n');
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

        _allIngredients.clear();
        for (var category in _ingredientCategories) {
          final categoryIngredients = category['ingredients'] as List<dynamic>;
          for (var ingredient in categoryIngredients) {
            _allIngredients.add({
              'id': '${category['id']}_${ingredient['name']}',
              'name': ingredient['name'],
              'unitTypes': ingredient['unitTypes'],
              'category': category['name'],
            });
          }
        }
        _initializeSelectedIngredients();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load ingredients: $e';
      });
      print('Error loading ingredients: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

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
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate() || _selectedIngredients.isEmpty) {
      setState(() {
        _errorMessage =
            _selectedIngredients.isEmpty
                ? 'Please add at least one ingredient'
                : 'Please fill in all required fields';
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload new image if selected
      if (_imageFile != null) {
        final imageUrl = await _uploadFile(
          _imageFile!,
          'recipes/${_editedRecipe.id}/image.jpg',
        );
        if (imageUrl != null) _editedRecipe.imageUrl = imageUrl;
      }

      // Upload new video if selected
      if (_videoFile != null) {
        final videoUrl = await _uploadFile(
          _videoFile!,
          'recipes/${_editedRecipe.id}/video.mp4',
        );
        if (videoUrl != null) _editedRecipe.videoUrl = videoUrl;
      }

      final updatedRecipe = Recipe(
        id: _editedRecipe.id,
        name: _editedRecipe.name,
        category: _editedRecipe.category,
        prepTime: _editedRecipe.prepTime,
        cookTime: _editedRecipe.cookTime,
        servings: _editedRecipe.servings,
        ingredients:
            _selectedIngredients
                .map(
                  (ingredient) => RecipeIngredient(
                    ingredientId: ingredient['id'],
                    name: ingredient['name'],
                    amount: ingredient['amount'],
                    unit: ingredient['unit'],
                  ),
                )
                .toList(),
        directions: _directionsController.text.split('\n'),
        nutritionalInfo: _parseNutritionalInfo(_nutritionalController.text),
        imageUrl: _editedRecipe.imageUrl,
        videoUrl: _editedRecipe.videoUrl,
        userId: _editedRecipe.userId,
        author: _editedRecipe.author,
        createdAt: _editedRecipe.createdAt,
      );

      // Update recipe
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(_editedRecipe.id)
          .update({
            'name': _editedRecipe.name,
            'category': _editedRecipe.category,
            'prepTime': _editedRecipe.prepTime,
            'cookTime': _editedRecipe.cookTime,
            'servings': _editedRecipe.servings,
            'ingredients':
                _selectedIngredients.map((ingredient) {
                  return {
                    'ingredientId': ingredient['id'],
                    'name': ingredient['name'],
                    'amount': ingredient['amount'],
                    'unit': ingredient['unit'],
                  };
                }).toList(),
            'directions': _directionsController.text.split('\n'),
            'nutritionalInfo': _parseNutritionalInfo(
              _nutritionalController.text,
            ),
            'imageUrl': _editedRecipe.imageUrl,
            'videoUrl': _editedRecipe.videoUrl,
            'updatedAt': Timestamp.now(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe updated successfully')),
      );

      Navigator.of(context).pop(updatedRecipe);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating recipe: $e')));
    } finally {
      setState(() => _isLoading = false);
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
        _buildSectionHeader("INGREDIENTS"),
        const SizedBox(height: 8),

        // Selected ingredients list
        if (_selectedIngredients.isNotEmpty)
          Column(
            children:
                _selectedIngredients.map((ingredient) {
                  return ListTile(
                    title: Text(ingredient['name'] ?? 'Unknown Ingredient'),
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

        // Add ingredient controls
        Row(
          children: [
            // Smaller ingredient dropdown
            Expanded(
              flex: 2, // Reduced from flex: 3
              child: DropdownButtonFormField<Map<String, dynamic>>(
                value: _currentIngredient,
                items:
                    _allIngredients.map<DropdownMenuItem<Map<String, dynamic>>>(
                      (ingredient) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: ingredient,
                          child: Text(
                            '${ingredient['name']} (${ingredient['category']})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ).toList(),
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
                decoration: _inputDecoration(labelText: 'Ingredient'),
                isExpanded: true, // Ensures text doesn't overflow
              ),
            ),

            const SizedBox(width: 8),
            // Amount field (same size)
            SizedBox(
              width: 80, // Fixed width
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(labelText: 'Amount'),
                onChanged: (value) {
                  setState(() {
                    _currentAmount = double.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            // Unit dropdown (same size)
            SizedBox(
              width: 80, // Fixed width
              child: DropdownButtonFormField<String>(
                value: _currentUnit,
                items:
                    (_currentIngredient?['unitTypes'] as List<dynamic>? ?? [])
                        .map<DropdownMenuItem<String>>((unit) {
                          return DropdownMenuItem<String>(
                            value: unit as String,
                            child: Text(unit, overflow: TextOverflow.ellipsis),
                          );
                        })
                        .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _currentUnit = value;
                  });
                },
                decoration: _inputDecoration(labelText: 'Unit'),
              ),
            ),
          ],
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
            'Edit Recipe',
            style: TextStyle(
              fontFamily: 'AlbertSans',
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFF8210),
            ),
          ),
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              height: 2,
              color: const Color.fromARGB(255, 234, 113, 15).withOpacity(0.2),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Section
                        _buildSectionHeader('IMAGE'),
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
                                    : _editedRecipe.imageUrl != null
                                    ? Image.network(
                                      _editedRecipe.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              _buildPlaceholder(
                                                'Tap to add image',
                                              ),
                                    )
                                    : _buildPlaceholder('Tap to add image'),
                          ),
                        ),
                        if (_imageFile != null ||
                            _editedRecipe.imageUrl != null)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _imageFile = null;
                                _editedRecipe.imageUrl = null;
                              });
                            },
                            child: const Text(
                              'Remove Image',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 16),

                        // Category Dropdown
                        _buildSectionHeader('CATEGORY'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _editedRecipe.category,
                          items:
                              const [
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
                              _editedRecipe.category = newValue!;
                            });
                          },
                          decoration: _inputDecoration(),
                        ),
                        const SizedBox(height: 16),

                        // Recipe Name
                        _buildSectionHeader('NAME'),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: _editedRecipe.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          decoration: _inputDecoration(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a recipe name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _editedRecipe.name = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Time Fields
                        _buildTimeFields(),
                        const SizedBox(height: 16),

                        // Servings
                        _buildSectionHeader('SERVINGS'),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: _editedRecipe.servings.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          decoration: _inputDecoration(),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter servings';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _editedRecipe.servings =
                                  int.tryParse(value) ?? _editedRecipe.servings;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Ingredients Section
                        _buildIngredientsSection(),

                        // Directions
                        _buildSectionHeader('DIRECTIONS'),
                        const SizedBox(height: 8),
                        _buildEditableSection(_directionsController),
                        const SizedBox(height: 16),

                        // Nutritional Info
                        _buildSectionHeader(
                          'NUTRITIONAL INFORMATION (PER SERVING)',
                        ),
                        const SizedBox(height: 8),
                        _buildEditableSection(_nutritionalController),
                        const SizedBox(height: 16),

                        // Video Tutorial
                        _buildSectionHeader('TUTORIAL'),
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
                                    : _editedRecipe.videoUrl != null
                                    ? const Center(
                                      child: Icon(
                                        Icons.videocam,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    )
                                    : const Center(
                                      child: Text(
                                        'Tap to add video',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                          ),
                        ),
                        if (_videoFile != null ||
                            _editedRecipe.videoUrl != null)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _videoFile = null;
                                _editedRecipe.videoUrl = null;
                              });
                            },
                            child: const Text(
                              'Remove Video',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 32),

                        // Error Message
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),

                        // Save/Discard Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton('DISCARD', Colors.grey, () {
                              Navigator.of(context).pop();
                            }),
                            _buildActionButton(
                              'SAVE',
                              const Color(0xFFFF8210),
                              _saveRecipe,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: const Color(0xFFFFDB4F),
      ),
    );
  }

  Widget _buildPlaceholder(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(color: const Color(0xFF9B9B9B)),
        textAlign: TextAlign.center,
      ),
    );
  }

  InputDecoration _inputDecoration({String? labelText}) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: const Color(0xFFFFDB4F)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: const Color(0xFFFFDB4F)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: const Color(0xFFFFDB4F)),
      ),
    );
  }

  Widget _buildTimeFields() {
    return Column(
      children: [
        // Prep Time
        _buildSectionHeader('PREP TIME'),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: _editedRecipe.prepTime,
          style: const TextStyle(fontWeight: FontWeight.w600),
          decoration: _inputDecoration(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter prep time';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _editedRecipe.prepTime = value;
            });
          },
        ),
        const SizedBox(height: 16),

        // Cook Time
        _buildSectionHeader('COOK TIME'),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: _editedRecipe.cookTime,
          style: const TextStyle(fontWeight: FontWeight.w600),
          decoration: _inputDecoration(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter cook time';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _editedRecipe.cookTime = value;
            });
          },
        ),
        const SizedBox(height: 16),

        // Total Time
        _buildSectionHeader('TOTAL TIME'),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: '${_editedRecipe.prepTime} + ${_editedRecipe.cookTime}',
          style: const TextStyle(fontWeight: FontWeight.w600),
          decoration: _inputDecoration(),
          readOnly: true,
        ),
      ],
    );
  }

  Widget _buildEditableSection(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFDB4F)),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
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
              icon: Image.asset(
                selectedBottomIndex == 0
                    ? 'assets/HomeIconOnClick.png'
                    : 'assets/home.png',
                width: 24,
                height: 24,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                selectedBottomIndex == 1
                    ? 'assets/ExploreIconOnClick.png'
                    : 'assets/search.png',
                width: 24,
                height: 24,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                selectedBottomIndex == 2
                    ? 'assets/MyProfileIconOnClick.png'
                    : 'assets/profile.png',
                width: 24,
                height: 24,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
