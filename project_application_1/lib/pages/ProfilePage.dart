import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Components/recipeCard2.dart';
import '../screens/home_page.dart';
import '../screens/explore_page.dart';
import '../models/recipe_model.dart';
import '../recipepage.dart';
import '../editprofilepage.dart';
import '../createrecipepage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedOption = "";
  bool isCreatedSelected = true;
  int _selectedIndex = 2;
  bool isTappedLeft = false;
  bool isTappedRight = false;
  User? currentUser;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  // For recipes
  List<Recipe> createdRecipes = [];
  List<Recipe> savedRecipes = [];
  bool isLoadingRecipes = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser!.uid)
                .get();

        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data();
          });
          await _fetchUserRecipes();
        }
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchUserRecipes() async {
    if (currentUser == null) return;

    setState(() {
      isLoadingRecipes = true;
    });

    try {
      final createdQuery =
          await FirebaseFirestore.instance
              .collection('recipes')
              .where('userId', isEqualTo: currentUser!.uid)
              .get();

      final created =
          createdQuery.docs
              .map((doc) => Recipe.fromMap(doc.data(), doc.id))
              .toList();

      final savedIds = userData?['savedRecipes'] as List<dynamic>? ?? [];
      final saved = <Recipe>[];

      if (savedIds.isNotEmpty) {
        final savedQuery =
            await FirebaseFirestore.instance
                .collection('recipes')
                .where(FieldPath.documentId, whereIn: savedIds)
                .get();

        saved.addAll(
          savedQuery.docs.map((doc) => Recipe.fromMap(doc.data(), doc.id)),
        );
      }

      setState(() {
        createdRecipes = created;
        savedRecipes = saved;
        isLoadingRecipes = false;
      });
    } catch (e) {
      print('Error fetching recipes: $e');
      setState(() {
        isLoadingRecipes = false;
      });
    }
  }

  //popup for followers and following
  void _showPopup(String title) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Color(0xff0eddd2)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0Xff0eddd2),
                    fontFamily: 'AlbertSans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),
                // List of followers/following would go here
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      userData?['profileImage'] ?? '',
                    ),
                  ),
                  title: Text(userData?['username'] ?? 'User'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //menu options
  void _showMenuOptions() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 110, 10, 0),
      items: [
        PopupMenuItem(
          child: Text(
            "Log out",
            style: TextStyle(
              fontFamily: 'AlbertSans',
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color:
                  selectedOption == "Log out"
                      ? Color(0xffff8210)
                      : Color(0xff000000),
            ),
          ),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            // Navigate to login page or handle logout
          },
        ),
        PopupMenuItem(
          child: Text(
            "Edit profile",
            style: TextStyle(
              fontFamily: 'AlbertSans',
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color:
                  selectedOption == "Edit profile"
                      ? Color(0xffff8210)
                      : Color(0xff000000),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => EditProfilePage(
                      userData: userData ?? {},
                      onProfileUpdated:
                          _fetchCurrentUser, // This will refresh the profile data
                    ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ExplorePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Please sign in to view your profile"),
              ElevatedButton(
                onPressed: () {
                  // Navigate to login page
                },
                child: Text("Sign In"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Profile",
          style: TextStyle(
            fontFamily: 'AlbertSans',
            fontWeight: FontWeight.w700,
            fontSize: 25,
            color: Color(0xFFFF8210),
          ),
        ),
        backgroundColor: Color(0xffffffff),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Container(color: Color(0xFFFF8210), height: 2),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.more_horiz, color: Color(0xFFFF8210)),
                onPressed: _showMenuOptions,
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile image and other content
            Expanded(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage:
                        userData?['profileImage'] != null
                            ? NetworkImage(userData!['profileImage'])
                            : AssetImage('images/ProfileImage.png')
                                as ImageProvider,
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(height: 10),
                  Text(
                    userData?['username'] ??
                        currentUser?.email?.split('@')[0] ??
                        'User',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'AlbertSans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    currentUser?.email ?? '',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showPopup("Followers");
                          setState(() {
                            isTappedLeft = true;
                            isTappedRight = false;
                          });
                        },
                        child: Text(
                          "${userData?['followers']?.length ?? 0} followers",
                          style: TextStyle(
                            color: Color(0xff0eddd2),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            decoration:
                                isTappedLeft
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(height: 20, width: 2, color: Color(0xff0eddd2)),
                      SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          _showPopup("Following");
                          setState(() {
                            isTappedLeft = false;
                            isTappedRight = true;
                          });
                        },
                        child: Text(
                          "${userData?['following']?.length ?? 0} following",
                          style: TextStyle(
                            color: Color(0xff0eddd2),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            decoration:
                                isTappedRight
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Created and Saved buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed:
                            () => setState(() => isCreatedSelected = true),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xffffdb4f)),
                          backgroundColor:
                              isCreatedSelected
                                  ? Color(0xffffdb4f)
                                  : Color(0xffffffff),
                        ),
                        child: Text(
                          "CREATED",
                          style: TextStyle(
                            fontFamily: 'AlbertSans',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color:
                                isCreatedSelected
                                    ? Color(0xffffffff)
                                    : Color(0xffffdb4f),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      OutlinedButton(
                        onPressed:
                            () => setState(() => isCreatedSelected = false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xffffdb4f), width: 2),
                          backgroundColor:
                              !isCreatedSelected
                                  ? Color(0xffffdb4f)
                                  : Color(0xffffffff),
                        ),
                        child: Text(
                          "SAVED",
                          style: TextStyle(
                            fontFamily: 'AlbertSans',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color:
                                !isCreatedSelected
                                    ? Color(0xffffffff)
                                    : Color(0xffffdb4f),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Content for CREATED or SAVED state
            Expanded(
              child:
                  isLoadingRecipes
                      ? Center(child: CircularProgressIndicator())
                      : isCreatedSelected
                      ? _buildCreatedRecipes()
                      : _buildSavedRecipes(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          border: Border.all(color: Color(0xff9b9b9b), width: 1.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(80.0),
            topRight: Radius.circular(80.0),
          ),
          child: SizedBox(
            height: 80,
            child: BottomNavigationBar(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              selectedItemColor: Color(0xFFFF8210),
              unselectedItemColor: Color(0xff9b9b9b),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'images/HomeIcon.png',
                    width: 30,
                    height: 30,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'images/ExploreIcon.png',
                    width: 30,
                    height: 30,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'images/MyProfileIcon.png',
                    width: 30,
                    height: 30,
                  ),
                  label: "",
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildCreatedRecipes() {
    if (createdRecipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 50, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No recipes created yet",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to create recipe page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateRecipePage()),
                ).then((_) {
                  // Refresh the recipes when returning from CreateRecipePage
                  _fetchUserRecipes();
                });
              },
              child: Text("Create Your First Recipe"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFDB4F),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: createdRecipes.length + 1, // +1 for the "add" button
      itemBuilder: (context, index) {
        if (index == 0) {
          return GestureDetector(
            onTap: () {
              // Navigate to create recipe page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateRecipePage()),
              ).then((_) {
                // Refresh the recipes when returning from CreateRecipePage
                _fetchUserRecipes();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Icon(Icons.add, size: 50, color: Color(0xFFFFDB4F)),
              ),
            ),
          );
        }

        final recipe = createdRecipes[index - 1];
        return RecipeCard2(
          image: recipe.imageUrl ?? 'images/placeholder_recipe.jpg',
          title: recipe.name,
          rating: "4.5",
          reviews: "10",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipePage(recipe: recipe),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSavedRecipes() {
    if (savedRecipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 50, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No saved recipes yet",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              "Save recipes you like to find them here later",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: savedRecipes.length,
      itemBuilder: (context, index) {
        final recipe = savedRecipes[index];
        return RecipeCard2(
          image: recipe.imageUrl ?? 'images/placeholder_recipe.jpg',
          title: recipe.name,
          rating: "4.5", // You might want to add rating to your Recipe model
          reviews: "10", // And reviews count
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipePage(recipe: recipe),
              ),
            );
          },
        );
      },
    );
  }
}
