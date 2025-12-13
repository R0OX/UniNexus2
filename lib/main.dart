import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 1. Import Firebase Core
import '../../ui/screens/login_screen.dart';
import '../../ui/screens/welcome_screen.dart';
// 2. Import the generated Firebase options
import 'firebase_options.dart';

// 3. Make main async to run the Firebase initialization
void main() async {
  // Ensure that Flutter is initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 4. Initialize Firebase using the current platform's options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully!');
  } catch (e) {
    // Log the error if initialization fails
    print('Firebase initialization error: $e');
  }

  runApp(const UniNexusApp());
}

class UniNexusApp extends StatelessWidget {
  const UniNexusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'UniNexus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // fontFamily: 'Inter', // Uncomment if configured
      ),
      // Assuming StaffWelcomeScreen is where the user starts
      home: const StaffWelcomeScreen(),
      // Example of setting initial route to LoginScreen instead of Welcome
      // home: const LoginScreen(),
    );
  }
}