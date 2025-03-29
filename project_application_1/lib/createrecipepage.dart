import 'package:flutter/material.dart';

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
  // ignore: prefer_final_fields
  bool _hasVideo = false;
  String? _imagePath;
  String? _selectedCategory;
  // ignore: unused_field
  String _recipeName = '';
  // ignore: unused_field
  String _prepTime = '';
  // ignore: unused_field
  String _cookTime = '';
  // ignore: unused_field
  String _totalTime = '';
  // ignore: unused_field
  String _servings = '';
  String _errorMessage = '';

  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController directionsController = TextEditingController();
  final TextEditingController nutritionalController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
            // ignore: deprecated_member_use
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          onTap: () {
                            // Implement image upload logic here
                            debugPrint("Upload image here");
                          },
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: _imagePath != null
                                ? Image.asset(_imagePath!, fit: BoxFit.cover)
                                : const Center(
                                    child: Text(
                                      "Upload a file here. We recommend using high quality files less than 20 MB.",
                                      style: TextStyle(color: Color(0xFF9B9B9B)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
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
                          items: <String>[
                            'Appetizers',
                            'Beverages',
                            'Breakfast',
                            'Desserts',
                            'Lunch & Dinner',
                            'Salads',
                            'Seafood',
                            'Snacks',
                            'Soups',
                            'Vegetarian'
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
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
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
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
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
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter prep time';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _prepTime = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
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
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter cook time';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _cookTime = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
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
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter total time';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _totalTime = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: const Color(0xFFFFDB4F)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter servings';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _servings = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildSection("INGREDIENTS", ingredientsController),
                        _buildSection("DIRECTIONS", directionsController),
                        _buildSection(
                            "NUTRITIONAL INFORMATION (PER SERVING)",
                            nutritionalController),
                        Text(
                          "TUTORIAL",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFFDB4F),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            // Implement video upload logic
                            debugPrint("Upload video here");
                          },
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: const Color(0xFFFFDB4F)),
                            ),
                            child: _hasVideo
                                ? const Center(
                                    child: Icon(Icons.videocam,
                                        color: Colors.grey, size: 50),
                                  )
                                : const Center(
                                    child: Text(
                                      "Tap to add video",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildButton("DISCARD", () {
                              Navigator.pop(context);
                            }),
                            _buildButton("POST", () {
                              if (_formKey.currentState!.validate()) {
                                // Form is valid, post recipe
                                // ignore: avoid_print
                                print('Posting recipe...');
                                // Implement post recipe logic here
                                setState(() {
                                  _errorMessage = ''; // Clear error message
                                });
                              } else {
                                setState(() {
                                  _errorMessage =
                                      'Oops! It looks like you missed a few things. Please fill in all the required fields to post.';
                                });
                              }
                            }),
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

  Widget _buildSection(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFDB4F),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFFDB4F)),
          ),
          child: TextField(
            controller: controller,
            maxLines: 10, // Increased maxLines
            minLines: 5,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF8210),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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