import 'package:flutter/material.dart';
import '../Components/recipeCard2.dart';
import '../screens/home_page.dart';
import '../screens/explore_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedOption = "";
  bool isCreatedSelected = true;

  int _selectedIndex = 2;

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

                // List of followers
                ListTile(leading: CircleAvatar(), title: Text("Follower 1")),
                ListTile(leading: CircleAvatar(), title: Text("Follower 2")),
                // Add more followers dynamically
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
          onTap: () {
            setState(() => selectedOption = "Log out");
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
            setState(() => selectedOption = "Edit profile");
          },
        ),
        PopupMenuItem(
          child: Text(
            "Delete account",
            style: TextStyle(
              fontFamily: 'AlbertSans',
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color:
                  selectedOption == "Delete account"
                      ? Color(0xffff8210)
                      : Color(0xff000000),
            ),
          ),
          onTap: () {
            setState(() => selectedOption = "Delete account");
          },
        ),
      ],
    );
  }

  bool isTappedLeft = false;
  bool isTappedRight = false;

  // Function to handle page navigation
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
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    backgroundImage: AssetImage('images/ProfileImage.png'),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "JohnDoe123",
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'AlbertSans',
                      fontWeight: FontWeight.w700,
                    ),
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
                          "10 followers",
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
                          "20 following",
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
                  isCreatedSelected
                      ? Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 220.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.add,
                                      size: 70.0,
                                      color: Color(0xffffdb4f),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: RecipeCard2(
                                      image: 'images/ChocolateChipCookies.jpg',
                                      title: "Chocolate Chip Cookies",
                                      rating: "3.7",
                                      reviews: "2",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                      : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: RecipeCard2(
                                      image: 'images/FluffyPancakes.jpg',
                                      title: "Fluffy Pancakes",
                                      rating: "4.0",
                                      reviews: "2",
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: RecipeCard2(
                                      image: 'images/ChocolateChipCookies.jpg',
                                      title: "Chocolate Chip Cookies",
                                      rating: "3.7",
                                      reviews: "2",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
}
