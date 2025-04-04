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
  User? currentUser;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  List<Recipe> createdRecipes = [];
  List<Recipe> savedRecipes = [];

  List<dynamic> followers = [];
  List<dynamic> following = [];

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
            followers = userDoc.data()?['followers'] ?? [];
            following = userDoc.data()?['following'] ?? [];
          });

          await _fetchUserRecipes();
        }
      }
    } catch (e) {
      print('Error fetching user: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchUserRecipes() async {
    if (currentUser == null) return;

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

      List<Recipe> saved = [];
      if (savedIds.isNotEmpty) {
        final savedQuery =
            await FirebaseFirestore.instance
                .collection('recipes')
                .where(FieldPath.documentId, whereIn: savedIds)
                .get();

        saved =
            savedQuery.docs
                .map((doc) => Recipe.fromMap(doc.data(), doc.id))
                .toList();
      }

      setState(() {
        createdRecipes = created;
        savedRecipes = saved;
      });
    } catch (e) {
      print('Error fetching recipes: $e');
    }
  }

  void _showPopup(String title) {
    final List<dynamic> listToShow =
        title == "Followers" ? followers : following;

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
            constraints: BoxConstraints(maxHeight: 400),
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
                    color: Color(0xff0eddd2),
                    fontFamily: 'AlbertSans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),
                listToShow.isEmpty
                    ? Text("No $title found.")
                    : Expanded(
                      child: ListView.builder(
                        itemCount: listToShow.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<DocumentSnapshot>(
                            future:
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(listToShow[index])
                                    .get(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return ListTile(title: Text("Loading..."));
                              }

                              final data =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      data['profileImage'] != null
                                          ? NetworkImage(data['profileImage'])
                                          : AssetImage(
                                                'images/ProfileImage.png',
                                              )
                                              as ImageProvider,
                                ),
                                title: Text(data['username'] ?? 'User'),
                                subtitle: Text(data['email'] ?? ''),
                              );
                            },
                          );
                        },
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

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
            ),
          ),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
          },
        ),
        PopupMenuItem(
          child: Text(
            "Edit profile",
            style: TextStyle(
              fontFamily: 'AlbertSans',
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => EditProfilePage(
                      userData: userData ?? {},
                      onProfileUpdated: _fetchCurrentUser,
                    ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ExplorePage()),
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
              ElevatedButton(onPressed: () {}, child: Text("Sign In")),
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
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Container(color: Color(0xFFFF8210), height: 2),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: Color(0xFFFF8210)),
            onPressed: _showMenuOptions,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
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
                  Text(
                    currentUser?.email ?? '',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _showPopup("Followers"),
                        child: Text(
                          "${followers.length} followers",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff0eddd2),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(height: 20, width: 2, color: Color(0xff0eddd2)),
                      SizedBox(width: 15),
                      GestureDetector(
                        onTap: () => _showPopup("Following"),
                        child: Text(
                          "${following.length} following",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff0eddd2),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
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
                                  : Colors.white,
                        ),
                        child: Text(
                          "CREATED",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'AlbertSans',
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      OutlinedButton(
                        onPressed:
                            () => setState(() => isCreatedSelected = false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xffffdb4f)),
                          backgroundColor:
                              !isCreatedSelected
                                  ? Color(0xffffdb4f)
                                  : Colors.white,
                        ),
                        child: Text(
                          "SAVED",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'AlbertSans',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  isCreatedSelected
                      ? _buildRecipeGrid(createdRecipes, showAddButton: true)
                      : _buildRecipeGrid(savedRecipes),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFFFF8210),
        unselectedItemColor: Color(0xff9b9b9b),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('images/HomeIcon.png', width: 30, height: 30),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/ExploreIcon.png', width: 30, height: 30),
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
    );
  }

  Widget _buildRecipeGrid(List<Recipe> recipes, {bool showAddButton = false}) {
    return recipes.isEmpty
        ? Center(
          child: Text(
            "No recipes found",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
        : GridView.builder(
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: recipes.length + (showAddButton ? 1 : 0),
          itemBuilder: (context, index) {
            if (showAddButton && index == 0) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CreateRecipePage()),
                  ).then((_) => _fetchUserRecipes());
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

            final recipe = recipes[showAddButton ? index - 1 : index];
            return RecipeCard2(
              image: recipe.imageUrl ?? 'images/placeholder_recipe.jpg',
              title: recipe.name,
              rating: "4.5",
              reviews: "10",
              isSaved: true,
              onToggleSave: () {},
            );
          },
        );
  }
}
