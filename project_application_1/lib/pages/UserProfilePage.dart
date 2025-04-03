import 'package:flutter/material.dart';
import '../Components/RecipeCard.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isFollowed = false;
  int _selectedIndex = 2; // Default to profile tab

  // Popup for Followers and Following
  void _showPopup(String title) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('images/ProfileImage.png'),
                    backgroundColor:
                        Colors.transparent, // Make background transparent
                  ),
                  title: Text("User 1"),
                ),
                SizedBox(height: 5),
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('images/ProfileImage.png'),
                    backgroundColor:
                        Colors.transparent, // Make background transparent
                  ),
                  title: Text("User 2"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isTappedLeft = false;
  bool isTappedRight = false;

  // void _onItemTapped(int index) {
  //   if (index == 2) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomePage()),
  //     );
  //   } else if (index == 1) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => ExplorePage()),
  //     );
  //   } else {
  //     setState(() {
  //       selectedBottomIndex = index;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Container(color: Color(0xFFFF8210), height: 2),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('images/ProfileImage.png'),
                    backgroundColor:
                        Colors.transparent, // Make background transparent
                  ),
                  SizedBox(height: 10),

                  // Username
                  Text(
                    "JaneDoe456",
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'AlbertSans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 5),

                  // Followers & Following Section
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
                          "10 followers",
                          style: TextStyle(
                            color: Color(0xff0eddd2),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            decoration:
                                isTappedLeft
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                            decorationColor:
                                isTappedRight
                                    ? Color(0xff0eddd2)
                                    : Colors
                                        .transparent, // Color of the underline
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        height: 20,
                        width: 2,
                        color: Color(0xff0eddd2),
                      ), // Divider
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
                          "20 following",
                          style: TextStyle(
                            color: Color(0xff0eddd2),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            decoration:
                                isTappedRight
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                            decorationColor:
                                isTappedRight
                                    ? Color(0xff0eddd2)
                                    : Colors
                                        .transparent, // Color of the underline
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Follow Button
                  OutlinedButton(
                    onPressed: () => setState(() => isFollowed = !isFollowed),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xff0eddd2), width: 2),
                      backgroundColor:
                          isFollowed ? Colors.white : Color(0xff0eddd2),
                    ),
                    child: Text(
                      isFollowed ? "FOLLOWING" : "FOLLOW",
                      style: TextStyle(
                        fontFamily: 'AlbertSans',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: isFollowed ? Color(0xff0eddd2) : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SizedBox(
                height: 200.0, // Fixed height for the Expanded widget
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 8,
                          ), // Adjust margin as needed
                          child: RecipeCard(
                            image: 'images/FluffyPancakes.jpg',
                            title: "Fluffy Pancakes",
                            rating: "4.0",
                            reviews: "12",
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8), // Apply same margin
                          child: RecipeCard(
                            image: 'images/ChocolateChipCookies.jpg',
                            title: "Chocolate Chip Cookies",
                            rating: "3.7",
                            reviews: "2",
                          ),
                        ),
                      ],
                    ),

                    // Add space below the Row using SizedBox
                    SizedBox(height: 10), // Adjust the height as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
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
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),

          child: BottomNavigationBar(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            selectedItemColor: Color(0xFFFF8210),
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
      backgroundColor: Colors.white,
    );
  }
}
