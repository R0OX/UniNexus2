import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'faculty_home_screen.dart';
import 'halls_error_screen.dart';

class HallsScreen extends StatefulWidget {
  const HallsScreen({super.key});

  @override
  State<HallsScreen> createState() => _HallsScreenState();
}

class _HallsScreenState extends State<HallsScreen> {
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // --- LOGIC: Get Current Time Slot Key ---
  // Returns keys exactly like "9:00-9:50" to match your Firebase fields
  String _getCurrentTimeSlot() {
    final now = DateTime.now();
    int totalMinutes = now.hour * 60 + now.minute;
    int toMin(int h, int m) => h * 60 + m;

    if (totalMinutes >= toMin(9, 0) && totalMinutes < toMin(9, 50)) return "9:00-9:50";
    if (totalMinutes >= toMin(9, 50) && totalMinutes < toMin(10, 40)) return "9:50-10:40";
    if (totalMinutes >= toMin(10, 50) && totalMinutes < toMin(11, 40)) return "10:50-11:40";
    if (totalMinutes >= toMin(11, 40) && totalMinutes < toMin(12, 30)) return "11:40-12:30";
    if (totalMinutes >= toMin(13, 0) && totalMinutes < toMin(13, 50)) return "1:00-1:50";
    if (totalMinutes >= toMin(13, 50) && totalMinutes < toMin(14, 40)) return "1:50-2:40";
    if (totalMinutes >= toMin(14, 50) && totalMinutes < toMin(15, 40)) return "2:50-3:40";
    if (totalMinutes >= toMin(15, 40) && totalMinutes < toMin(16, 30)) return "3:40-4:30";
    if (totalMinutes >= toMin(16, 30) && totalMinutes < toMin(17, 20)) return "4:30-5:20";
    if (totalMinutes >= toMin(17, 20) && totalMinutes < toMin(18, 10)) return "5:20-6:10";

    return "OFF_HOURS";
  }

  @override
  Widget build(BuildContext context) {
    String currentSlotKey = _getCurrentTimeSlot();

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

      // --- BOTTOM NAV BAR ---
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
              _buildNavBarItem('assets/images/menu.png', "Community", 0),
              _buildNavBarItem('assets/images/calendar.png', "Schedule", 1),
              const SizedBox(width: 48), // Space for FAB
              _buildNavBarItem('assets/images/qa.png', "Q&A", 2),
              _buildNavBarItem('assets/images/profile.png', "Profile", 3),
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
          child: Stack(
            children: [
              Column(
                children: [
                  // -- Header --
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Image.asset('assets/images/menu.png', width: 28, color: const Color(0xFF237ABA))
                        ),
                        const Text(
                          "Halls",
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

                  // -- Search Bar --
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search Hall (e.g. A 108)",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7B61FF).withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // -- Halls List (StreamBuilder) --
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('halls').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Text(
                                "No halls data found.",
                                style: TextStyle(color: Colors.black54),
                              )
                          );
                        }

                        // Parse and Filter Data
                        final docs = snapshot.data!.docs.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;

                          // COMBINE FIELDS: "A" + "101" -> "A 101"
                          String building = (data['building'] ?? "").toString();
                          String code = (data['hallCode'] ?? "").toString();
                          String fullName = "$building $code".trim().toLowerCase();

                          return fullName.contains(_searchQuery);
                        }).toList();

                        if (docs.isEmpty) {
                          return const Center(child: Text("No matches found."));
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data = docs[index].data() as Map<String, dynamic>;

                            // 1. Construct Name: "A 101"
                            String building = data['building'] ?? "";
                            String code = data['hallCode'] ?? "";
                            String displayName = "$building $code".trim();

                            // 2. Check Status (Boolean)
                            // If key exists and is TRUE -> Busy (Red)
                            // If key is FALSE or doesn't exist -> Free (Green)
                            bool isBusy = false;

                            if (currentSlotKey != "OFF_HOURS" && data.containsKey(currentSlotKey)) {
                              isBusy = data[currentSlotKey] == true;
                            }

                            return _buildHallCard(displayName, isBusy);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),

              // -- 4. THE REPORT BUTTON --
              Positioned(
                bottom: 100,
                right: 24,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7B61FF).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      // --- NAVIGATE TO ERROR SCREEN ---
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HallErrorScreen()),
                      );
                    },
                    icon: const Icon(Icons.warning_amber_rounded, color: Color(0xFF7B61FF), size: 32),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widget: The Hall Card ---
  Widget _buildHallCard(String name, bool isBusy) {
    // Logic: isBusy (true) = RED, !isBusy (false) = GREEN
    Color statusColor = isBusy ? Colors.red : Colors.greenAccent.shade700;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF237ABA).withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/images/main_calender.png', width: 28, height: 28, color: const Color(0xFF5C5C80)),
              const SizedBox(width: 15),
              Container(height: 30, width: 1, color: Colors.grey.shade300),
              const SizedBox(width: 15),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5C7CFA),
                ),
              ),
            ],
          ),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.4),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper: Bottom Nav Item ---
  Widget _buildNavBarItem(String iconPath, String label, int index) {
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