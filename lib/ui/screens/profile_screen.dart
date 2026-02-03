import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'faculty_home_screen.dart';
import 'qa_screen.dart';
import 'halls_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? userID;
  final String? firstName;
  final String? lastName;

  const ProfileScreen({
    super.key,
    this.userID,
    this.firstName,
    this.lastName,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _selectedIndex = 3;
  final Color _mainPurple = const Color(0xFF7B61FF);
  final Gradient _fabGradient = const LinearGradient(
    colors: [Color(0xFF237ABA), Color(0xFF7B61FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Identity and Contact Variables
  String _displayFirstName = "User";
  String _displayLastName = "";
  String _displayID = "";
  String _displayEmail = "N/A";
  String _displayPhone = "N/A";
  String _displayFaculty = "N/A";
  String _displayNID = "N/A";

  // Student-Specific String Variables
  String _displayYear = "N/A";    // Handled as String
  String _displaySection = "N/A"; // Handled as String

  bool _isStudent = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataFromPrefs();
  }

  Future<void> _loadDataFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();

      setState(() {
        // Basic Info
        _displayID = prefs.getString('ID') ?? prefs.getString('userCode') ?? widget.userID ?? "N/A";
        _displayFirstName = prefs.getString('fName') ?? prefs.getString('userFirstName') ?? widget.firstName ?? "User";
        _displayLastName = prefs.getString('lName') ?? prefs.getString('userLastName') ?? widget.lastName ?? "";

        // Contact Info
        _displayEmail = prefs.getString('email') ?? "N/A";
        _displayPhone = prefs.getString('pNum') ?? "N/A";
        _displayFaculty = prefs.getString('faculty') ?? "N/A";
        _displayNID = prefs.getString('nid') ?? prefs.getString('nationalID') ?? "N/A";

        // Role Detection
        _isStudent = _displayID.toUpperCase().startsWith('ST');

        // Student String Data
        if (_isStudent) {
          _displayYear = prefs.getString('year') ?? "N/A";
          _displaySection = prefs.getString('section') ?? "N/A";
        }

        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Profile Error: $e");
      setState(() => _isLoading = false);
    }
  }

  void _onNavBarTapped(int index) {
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HallsScreen()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const QAScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: _buildHomeFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: _mainPurple))
              : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildIdentityCard(),
                const SizedBox(height: 20),
                _buildDetailsList(),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset('assets/images/menu.png', width: 28, color: _mainPurple,
              errorBuilder: (c, o, s) => Icon(Icons.menu, color: _mainPurple)),
        ),
        const Text(
          "Profile",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF5C5C80)),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset('assets/images/uni.jpeg', width: 36, height: 36,
              errorBuilder: (c, o, s) => const Icon(Icons.school, size: 36)),
        ),
      ],
    );
  }

  Widget _buildIdentityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _mainPurple.withOpacity(0.5), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 70, height: 70,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF8B00FF)),
            child: const Icon(Icons.person, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 15),
          Container(height: 50, width: 1, color: Colors.grey.shade300),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$_displayFirstName $_displayLastName",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(_displayID,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _mainPurple.withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        children: [
          _buildProfileField("Faculty :", _displayFaculty),

          // Display Year and Section as Strings for Students
          if (_isStudent) ...[
            _buildProfileField("Academic Year :", _displayYear),
            _buildProfileField("Section :", _displaySection),
          ],

          _buildProfileField("E-mail :", _displayEmail),
          _buildProfileField("Phone no. :", _displayPhone),
          _buildProfileField("National ID :", _displayNID),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Divider(color: _mainPurple.withOpacity(0.2), thickness: 1),
        ],
      ),
    );
  }

  Widget _buildHomeFab() {
    return Container(
      height: 70, width: 70,
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
        BoxShadow(color: _mainPurple.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
      ]),
      child: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: double.infinity, height: double.infinity,
          decoration: BoxDecoration(shape: BoxShape.circle, gradient: _fabGradient),
          child: const Icon(Icons.home_rounded, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10.0,
      color: Colors.white,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavBarItem('assets/images/solidarity_1.png', "Community", 0),
          _buildNavBarItem('assets/images/calendar.png', "Schedule", 1),
          const SizedBox(width: 48),
          _buildNavBarItem('assets/images/qa.png', "Q&A", 2),
          _buildNavBarItem('assets/images/profile.png', "Profile", 3),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(String iconPath, String label, int index) {
    final isSelected = _selectedIndex == index;
    final Color itemColor = isSelected ? _mainPurple : Colors.grey.shade400;
    return GestureDetector(
      onTap: () => _onNavBarTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, width: 22, height: 22, color: itemColor,
              errorBuilder: (c, o, s) => Icon(Icons.circle, color: itemColor, size: 22)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: itemColor, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }
}