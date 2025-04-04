import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/saved_recipes_page.dart';
import '../Components/RecipeCard.dart';
import '../models/user_model.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isFollowed = false;
  int _selectedIndex = 2;
  bool isLoading = true;
  UserModel? user;
  List<Map<String, dynamic>> userRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

      if (userDoc.exists) {
        setState(() {
          user = UserModel.fromJson(userDoc.data()!);
        });
      } else {
        final userByEmail = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: widget.userId)
            .limit(1)
            .get();

        if (userByEmail.docs.isNotEmpty) {
          setState(() {
            user = UserModel.fromJson(userByEmail.docs.first.data());
          });
        }
      }

      if (user != null) {
        final recipesSnapshot = await FirebaseFirestore.instance
            .collection('recipes')
            .where('userId', isEqualTo: user!.id)
            .limit(2)
            .get();

        setState(() {
          userRecipes = recipesSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('User Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('User data not available'),
              Text('ID: ${widget.userId}'),
              ElevatedButton(
                onPressed: _loadUserData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: const Color(0xFFFF8210), height: 2),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Info
            Expanded(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: user!.additionalInfo?['photoUrl'] != null
                        ? NetworkImage(user!.additionalInfo!['photoUrl'])
                        : const AssetImage('images/ProfileImage.png') as ImageProvider,
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user!.username,
                    style: const TextStyle(
                      fontSize: 32,
                      fontFamily: 'AlbertSans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user!.email,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${user!.additionalInfo?['followerCount'] ?? 0} followers",
                        style: const TextStyle(
                          color: Color(0xff0eddd2),
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(height: 20, width: 2, color: const Color(0xff0eddd2)),
                      const SizedBox(width: 15),
                      Text(
                        "${user!.additionalInfo?['followingCount'] ?? 0} following",
                        style: const TextStyle(
                          color: Color(0xff0eddd2),
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () => setState(() => isFollowed = !isFollowed),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xff0eddd2), width: 2),
                      backgroundColor: isFollowed ? Colors.white : const Color(0xff0eddd2),
                    ),
                    child: Text(
                      isFollowed ? "FOLLOWING" : "FOLLOW",
                      style: TextStyle(
                        fontFamily: 'AlbertSans',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: isFollowed ? const Color(0xff0eddd2) : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Saved Recipes UI + User's Recipe Cards
            Expanded(
              child: Column(
                children: [
                  const Text(
                    "Your Saved Recipes",
                    style: TextStyle(
                      fontFamily: 'AlbertSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SavedRecipesPage()),
                      );
                    },
                    icon: const Icon(Icons.favorite_border),
                    label: const Text("View Saved Recipes"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFFF8210),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'AlbertSans',
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  const Text(
                    "Access all your favourites in one place!",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'AlbertSans',
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (userRecipes.isEmpty)
                    const Text("No recipes found")
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: userRecipes.map((recipe) {
                        return RecipeCard(
                          image: recipe['imageUrl'] ?? 'images/default_recipe.jpg',
                          title: recipe['name'] ?? 'Untitled Recipe',
                          rating: recipe['rating']?.toString() ?? "0",
                          reviews: recipe['reviewCount']?.toString() ?? "0",
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          border: Border.all(color: const Color(0xff9b9b9b), width: 1.0),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFFFF8210),
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
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
                icon: Image.asset('images/MyProfileIcon.png', width: 30, height: 30),
                label: "",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
