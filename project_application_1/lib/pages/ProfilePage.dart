import 'package:flutter/material.dart';
import 'package:flutter_application_2/Components/RecipeCard2.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
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
                //menu button
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
            //profile image
            Expanded(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('images/ProfileImage.png'),
                    backgroundColor:
                        Colors.transparent, // Make background transparent
                  ),
                  SizedBox(height: 10),
                  //user name
                  Text(
                    "JohnDoe123",
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

                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // CREATED button
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
                      // SAVED Button
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

            Expanded(
              child:
                  isCreatedSelected
                      ? Column(
                        children: [
                          Row(
                            children: [
                              // "Add" icon box
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
                                    alignment:
                                        Alignment.center, // Center the icon
                                    child: Icon(
                                      Icons.add,
                                      size:
                                          70.0, // You can adjust the size of the icon here
                                      color: Color(0xffffdb4f),
                                      // Icon color
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 5), // Space between the two boxes
                              // Recipe box without border color
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(20.0),
                                    // Removed border color here
                                  ),
                                  child: Align(
                                    alignment:
                                        Alignment.center, // Center the content
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
                          SizedBox(height: 20), // Space below the row
                          // Additional content or padding below
                          // You can add more widgets here if needed
                        ],
                      )
                      : Column(
                        children: [
                          Row(
                            children: [
                              // "Add" icon box
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(20.0),
                                    // Removed border color here
                                  ),
                                  child: Align(
                                    alignment:
                                        Alignment.center, // Center the content
                                    child: RecipeCard2(
                                      image: 'images/FluffyPancakes.jpg',
                                      title: "Fluffy Pancakes",
                                      rating: "4.0",
                                      reviews: "2",
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 2), // Space between the two boxes
                              // Recipe box without border color
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(20.0),
                                    // Removed border color here
                                  ),
                                  child: Align(
                                    alignment:
                                        Alignment.center, // Center the content
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
                          SizedBox(height: 20), // Space below the row
                          // Additional content or padding below
                          // You can add more widgets here if needed
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
            height: 80, // Change this value to adjust height
            child: BottomNavigationBar(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              selectedItemColor: Color(0xFFFF8210),
              unselectedItemColor: Color(0xff9b9b9b),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
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
