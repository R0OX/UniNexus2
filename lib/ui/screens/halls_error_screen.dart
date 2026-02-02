import 'package:flutter/material.dart';
import 'faculty_home_screen.dart'; // For navigation context if needed
import 'faculty_id_screen.dart';    // Placeholder

class HallErrorScreen extends StatefulWidget {
  const HallErrorScreen({super.key});

  @override
  State<HallErrorScreen> createState() => _HallErrorScreenState();
}

class _HallErrorScreenState extends State<HallErrorScreen> {
  // Controllers (Ready for backend logic later)
  final TextEditingController _hallNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedErrorType;

  // Dropdown Items
  final List<String> _errorTypes = [
    'Projector Issue',
    'Air Conditioner',
    'Lighting',
    'Furniture/Desk',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      // --- FAB (QR Code) ---
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
            // TODO: QR Action
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF237ABA), Color(0xFF5C9CE0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('assets/images/qr_code.png', color: Colors.white),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // --- BOTTOM NAV BAR (Visual Only) ---
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
              const SizedBox(width: 48), // Space for FAB
              _buildNavBarItem('assets/images/qa.png', "Q&A"),
              _buildNavBarItem('assets/images/profile.png', "Profile"),
            ],
          ),
        ),
      ),

      // --- MAIN BODY ---
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
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
            child: Column(
              children: [
                // 1. Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context), // Back button
                      child: Image.asset('assets/images/menu.png', width: 28, color: const Color(0xFF237ABA)),
                    ),
                    const Text(
                      "Hall Error",
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

                const SizedBox(height: 30),

                // 2. The Form Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF7B61FF).withOpacity(0.3), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF237ABA).withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -- Field 1: Hall Name --
                      _buildLabel("Hall name"),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _hallNameController,
                        hint: "Submit the errored hall's name",
                        icon: Icons.send_rounded, // Send icon inside
                        isButton: true,
                      ),

                      const SizedBox(height: 20),

                      // -- Field 2: Error Type (Dropdown) --
                      _buildLabel("Error Type"),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedErrorType,
                            hint: Text("Choose the error type", style: TextStyle(color: Colors.grey.shade400)),
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF5C5C80), size: 30),
                            items: _errorTypes.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedErrorType = newValue;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // -- Field 3: Description --
                      _buildLabel("Description"),
                      const SizedBox(height: 8),
                      Container(
                        height: 120,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: 5,
                          decoration: InputDecoration.collapsed(
                            hintText: "Submit your problem details",
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // -- Field 4: Attachment --
                      _buildLabel("Attachment"),
                      const SizedBox(height: 8),
                      _buildTextField(
                          controller: TextEditingController(), // Placeholder
                          hint: "Attach a photo if possible",
                          icon: Icons.add_rounded,
                          isButton: true, // Acts as a button
                          onIconTap: () {
                            // TODO: Open Gallery
                            print("Open Gallery");
                          }
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 3. Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Send to Firebase
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Error Report Submitted (UI Only)")),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF7B61FF), width: 2), // Purple Border
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5C5C80), // Dark Purple/Blue Text
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helpers ---

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    bool isButton = false,
    VoidCallback? onIconTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        readOnly: false,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          suffixIcon: icon != null
              ? GestureDetector(
            onTap: onIconTap,
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFF7B61FF).withOpacity(0.8), // Purple Icon Bg
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
          )
              : null,
        ),
      ),
    );
  }

  Widget _buildNavBarItem(String iconPath, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconPath,
          width: 24,
          height: 24,
          color: Colors.grey.shade400,
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