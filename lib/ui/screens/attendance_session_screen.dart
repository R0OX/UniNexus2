import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Using this to generate the QR
import 'faculty_home_screen.dart'; // For navigation context

class AttendanceSessionScreen extends StatefulWidget {
  const AttendanceSessionScreen({super.key});

  @override
  State<AttendanceSessionScreen> createState() => _AttendanceSessionScreenState();
}

class _AttendanceSessionScreenState extends State<AttendanceSessionScreen> {
  // Form Controllers
  final TextEditingController _durationController = TextEditingController();
  String? _selectedCourse;
  String? _selectedSessionType;

  // Mock Data (We will fetch these from Firebase later)
  final List<String> _courses = [
    'CCNA R&S II',
    'Network Security',
    'IOT Architecture',
    'Mobile Programming'
  ];

  final List<String> _sessionTypes = [
    'Lecture',
    'Section',
    'Lab'
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
                      "Attendance", // UPDATED TITLE
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

                // 2. QR Code Display Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF237ABA).withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // QR Code (Placeholder or Generated)
                      // We use the QrImageView to match the style of ID screen
                      QrImageView(
                        data: "Session-Placeholder-123", // Will be dynamic later
                        version: QrVersions.auto,
                        size: 200.0,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xFF4A90E2), // Blue-ish QR like design
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.circle,
                          color: Color(0xFF5C5C80),
                        ),
                        embeddedImage: const AssetImage('assets/images/uni.jpeg'),
                        embeddedImageStyle: const QrEmbeddedImageStyle(
                          size: Size(30, 30),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 3. Form Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF237ABA).withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -- Field 1: Course --
                      _buildLabel("Course"),
                      const SizedBox(height: 8),
                      _buildDropdownField(
                        value: _selectedCourse,
                        hint: "Choose the Course",
                        items: _courses,
                        onChanged: (val) => setState(() => _selectedCourse = val),
                      ),

                      const SizedBox(height: 16),

                      // -- Row: Session Type & Duration --
                      Row(
                        children: [
                          // Session Type
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Session Type"),
                                const SizedBox(height: 8),
                                _buildDropdownField(
                                  value: _selectedSessionType,
                                  hint: "Choose Type",
                                  items: _sessionTypes,
                                  onChanged: (val) => setState(() => _selectedSessionType = val),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Duration
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Duration"),
                                const SizedBox(height: 8),
                                Container(
                                  height: 55, // Match dropdown height
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF2F2F2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: TextField(
                                    controller: _durationController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Duration",
                                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 4. Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Generate Session Logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Session Created!")),
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
                      "Submit",
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
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF5C5C80), size: 28),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
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