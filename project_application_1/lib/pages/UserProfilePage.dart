import 'package:flutter/material.dart';
import '../screens/saved_recipes_page.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isFollowed = false;
  int _selectedIndex = 2;
  bool _isTappedLeft = false;
  bool _isTappedRight = false;

  void _showPopup(String title) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return _buildDialog(title);
      },
    );
  }

  Widget _buildDialog(String title) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCloseButton(),
            _buildDialogTitle(title),
            _buildListTile(),
            _buildListTile(),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: const Icon(Icons.close, color: Color(0xff0eddd2)),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildDialogTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 25,
        color: Color(0xff0eddd2),
        fontFamily: 'AlbertSans',
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildListTile() {
    return ListTile(
      leading: const CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage('images/ProfileImage.png'),
        backgroundColor: Colors.transparent,
      ),
      title: const Text("User "),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(color: const Color(0xFFFF8210), height: 2),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [_buildProfileSection(), _buildSavedRecipesSection()],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Expanded(
      child: Column(
        children: [
          _buildProfileImage(),
          _buildProfileName(),
          _buildFollowersAndFollowing(),
          _buildFollowButton(),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return const CircleAvatar(
      radius: 70,
      backgroundImage: AssetImage('images/ProfileImage.png'),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildProfileName() {
    return const Text(
      "JaneDoe456",
      style: TextStyle(
        fontSize: 32,
        fontFamily: 'AlbertSans',
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildFollowersAndFollowing() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_buildFollowers(), _buildFollowing()],
    );
  }

  Widget _buildFollowers() {
    return GestureDetector(
      onTap: () {
        _showPopup("Followers");
        setState(() {
          _isTappedLeft = true;
          _isTappedRight = false;
        });
      },
      child: Text(
        "10 followers",
        style: TextStyle(
          color: const Color(0xff0eddd2),
          fontWeight: FontWeight.w600,
          fontSize: 18,
          decoration:
              _isTappedLeft ? TextDecoration.underline : TextDecoration.none,
          decorationColor:
              _isTappedLeft ? const Color(0xff0eddd2) : Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildFollowing() {
    return GestureDetector(
      onTap: () {
        _showPopup("Following");
        setState(() {
          _isTappedLeft = false;
          _isTappedRight = true;
        });
      },
      child: Text(
        "20 following",
        style: TextStyle(
          color: const Color(0xff0eddd2),
          fontWeight: FontWeight.w600,
          fontSize: 18,
          decoration:
              _isTappedRight ? TextDecoration.underline : TextDecoration.none,
          decorationColor:
              _isTappedRight ? const Color(0xff0eddd2) : Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildFollowButton() {
    return OutlinedButton(
      onPressed: () => setState(() => _isFollowed = !_isFollowed),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xff0eddd2), width: 2),
        backgroundColor: _isFollowed ? Colors.white : const Color(0xff0eddd2),
      ),
      child: Text(
        _isFollowed ? "FOLLOWING" : "FOLLOW",
        style: TextStyle(
          fontFamily: 'AlbertSans',
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: _isFollowed ? const Color(0xff0eddd2) : Colors.white,
        ),
      ),
    );
  }

  Widget _buildSavedRecipesSection() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSavedRecipesTitle(),
          _buildViewSavedRecipesButton(),
          _buildSavedRecipesDescription(),
        ],
      ),
    );
  }

  Widget _buildSavedRecipesTitle() {
    return const Text(
      "Your Saved Recipes",
      style: TextStyle(
        fontFamily: 'AlbertSans',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildViewSavedRecipesButton() {
    return ElevatedButton.icon(
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
    );
  }

  Widget _buildSavedRecipesDescription() {
    return const Text(
      "Access all your favourites in one place!",
      style: TextStyle(
        fontSize: 14,
        fontFamily: 'AlbertSans',
        color: Colors.grey,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
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
    );
  }
}
