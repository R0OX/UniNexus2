import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FacultyIDScreen extends StatelessWidget {
  final String userID;
  final String userName;

  const FacultyIDScreen({
    super.key,
    required this.userID,
    required this.userName
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      // --- FAB (Home Button) ---
      // This button replaces the QR button and acts as a "Back" button
      floatingActionButton: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A90E2).withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context); // Go back to Home
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              // Different Gradient for Home Button (Blue/Purple reversed or same)
              gradient: LinearGradient(
                colors: [Color(0xFF237ABA), Color(0xFF5C9CE0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            // Home Icon
            child: const Icon(Icons.home_rounded, color: Colors.white, size: 32),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 5,
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10.0,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNavBarItem('assets/images/menu.png', "Community"),
              _buildNavBarItem('assets/images/calendar.png', "Schedule"),
              const SizedBox(width: 48), // Space for Home FAB
              _buildNavBarItem('assets/images/qa.png', "Q&A"),
              _buildNavBarItem('assets/images/profile.png', "Profile"),
            ],
          ),
        ),
      ),

      // --- Main Body ---
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // 1. Header (Menu, ID Title, Logo)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/menu.png', width: 28, color: const Color(0xFF237ABA)),
                      const Text(
                        "ID",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5C5C80),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset('assets/images/uni.jpeg', width: 36, height: 36),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 2. Main ID Card (Glassmorphism)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF237ABA).withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
                  ),
                  child: Column(
                    children: [
                      // Top Decorative Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildDot(12),
                          const SizedBox(width: 15),
                          Container(
                            width: 60,
                            height: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0E0FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(width: 15),
                          _buildDot(12),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // ID Badge Icon
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7B61FF).withOpacity(0.8), // Purple shade
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.badge_outlined, color: Colors.white, size: 40),
                      ),

                      const SizedBox(height: 40),

                      // --- GRADIENT QR CODE ---
                      // We use a ShaderMask to paint the QR code with a gradient
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            colors: [Color(0xFF237ABA), Color(0xFF9C2CF3)], // Blue to Purple
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcIn,
                        child: QrImageView(
                          data: userID, // The actual User ID (e.g. FA2022...)
                          version: QrVersions.auto,
                          size: 220.0,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Colors.black, // Overridden by ShaderMask
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Colors.black, // Overridden by ShaderMask
                          ),
                          // Embed Logo in Center (Optional, matched design "UN" logo in middle)
                          embeddedImage: const AssetImage('assets/images/uni.jpeg'),
                          embeddedImageStyle: const QrEmbeddedImageStyle(
                            size: Size(40, 40),
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Punch IN Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: Add Punch Logic (Geo-location or Database timestamp)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Punch Request Sent!")),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF7B61FF), width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            "Punch IN",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5C5C80),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40), // Bottom spacing
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildDot(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFE0E0FF),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildNavBarItem(String iconPath, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          iconPath,
          width: 24,
          height: 24,
          color: Colors.grey.shade400, // Inactive color
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}