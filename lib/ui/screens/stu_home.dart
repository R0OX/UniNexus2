import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // <<< Import LoginScreen for navigation after logout

// Keys for SharedPreferences (Duplicate these from login_screen.dart or put in a separate constants file)
const String _kRememberMeKey = 'rememberMe';
const String _kUserCodeKey = 'userCode';
const String _kUserFirstNameKey = 'userFirstName';
const String _kUserLastNameKey = 'userLastName';

class StuHomeScreen extends StatefulWidget {
  const StuHomeScreen({Key? key}) : super(key: key);

  @override
  State<StuHomeScreen> createState() => _StuHomeScreenState();
}

class _StuHomeScreenState extends State<StuHomeScreen> {
  int _currentIndex = 0;

  // State variables for the user's name
  String _firstName = 'Back';
  String _lastName = '';

  static const Color primaryBlue = Color(0xFF237ABA);
  static const Color textBlue = Color(0xFF0A4C7D);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Function to load name from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final fName = prefs.getString(_kUserFirstNameKey);
    final lName = prefs.getString(_kUserLastNameKey);

    // Only update state if data was found
    if (fName != null || lName != null) {
      setState(() {
        // Use the saved name or fallback to "Back" if null
        _firstName = fName ?? 'Back';
        _lastName = lName ?? '';
      });
    }
  }

  // --- NEW LOGOUT FUNCTION ---
  Future<void> _logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear all saved keys related to persistent login
    await prefs.remove(_kRememberMeKey);
    await prefs.remove(_kUserCodeKey);
    await prefs.remove(_kUserFirstNameKey);
    await prefs.remove(_kUserLastNameKey);

    if (mounted) {
      // Navigate back to the LoginScreen and replace the current screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ========= TOP BAR (unchanged) =========
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          'assets/images/menu.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Home',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: primaryBlue,

                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),

                const SizedBox(height: 24),

                // ========= PROFILE HEADER (unchanged) =========
                Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/profile.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // DYNAMIC WELCOME MESSAGE
                    Text(
                      'Welcome $_firstName $_lastName!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: textBlue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ========= CARD 1 (Schedule teaser) (unchanged) =========
                _StuHomeCard(
                  borderColor: primaryBlue,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi!',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: textBlue,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Want to check your\nschedule?',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          'assets/images/main_calender.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {},
                ),

                const SizedBox(height: 16),

                // ========= TRANSPARENT NOTIFICATIONS AREA (unchanged) =========
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: primaryBlue,
                        width: 1.5,
                      ),
                    ),
                    child: const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ========= CENTER QR BUTTON (unchanged) =========
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 62,
        height: 62,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: primaryBlue,
          onPressed: () {},
          child: Image.asset(
            'assets/images/qr_code.png',
            width: 30,
            height: 30,
          ),
        ),
      ),

      // ========= BOTTOM NAVIGATION (MODIFIED) =========
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StuBottomItem(
                image: 'assets/images/home.png',
                label: 'Home',
                selected: _currentIndex == 0,
                onTap: () => setState(() => _currentIndex = 0),
              ),
              // --- MODIFIED: SCHEDULE BUTTON IS NOW LOGOUT ---
              _StuBottomItem(
                image: 'assets/images/calendar.png', // You might want to use a logout icon here
                label: 'Logout', // Change label to Logout
                selected: _currentIndex == 1,
                onTap: _logoutUser, // <<< CALL LOGOUT FUNCTION
              ),
              const SizedBox(width: 40),
              _StuBottomItem(
                image: 'assets/images/qa.png',
                label: 'Q&A',
                selected: _currentIndex == 2,
                onTap: () => setState(() => _currentIndex = 2),
              ),
              _StuBottomItem(
                image: 'assets/images/user.png',
                label: 'Profile',
                selected: _currentIndex == 3,
                onTap: () => setState(() => _currentIndex = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========= REUSABLE CARD (unchanged) =========
class _StuHomeCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color borderColor;

  const _StuHomeCard({
    Key? key,
    required this.child,
    required this.borderColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ========= REUSABLE NAV ITEM (unchanged) =========
class _StuBottomItem extends StatelessWidget {
  final String image;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _StuBottomItem({
    Key? key,
    required this.image,
    required this.label,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Note: The selectedColor variable is redundant since it's not used.
    // final Color selectedColor = selected ? _StuHomeScreenState.primaryBlue : Colors.white;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Image.asset(
              image,
              width: 26,
              height: 26,
              // Note: If you don't have an asset named 'assets/images/logout.png',
              // the app will crash unless you update this path or use an existing icon.
              color: selected ? _StuHomeScreenState.primaryBlue : Colors.black54,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? _StuHomeScreenState.primaryBlue : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}