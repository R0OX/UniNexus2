import 'package:flutter/material.dart';
import '../../ui/screens/login_screen.dart';
import '../../ui/screens/SignUp_Screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  Container(
                    width: 247,
                    height: 247,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/uni.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // "Welcome To UniNexus"
                  Container(
                    width: 222,
                    height: 120,
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome To',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                            color: Color(0xFF0A4C7D),
                            height: 1.5,
                            letterSpacing: 0,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'UniNexus',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                            color: Color(0xFF0A4C7D),
                            height: 1.5,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  Container(
                    width: 236,
                    height: 70,
                    alignment: Alignment.center,
                    child: const Text(
                      'Transform your\nuniversity experience',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Color(0xFF0A4C7D),
                        height: 1.5,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Sign Up Button
                  Container(
                    width: 327,
                    height: 66,
                    decoration: BoxDecoration(
                      color: const Color(0xFF237ABA).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFFFFF),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  // Spacing between buttons
                  const SizedBox(height: 16),

                  // Login Button
                  Container(
                    width: 327,
                    height: 66,
                    decoration: BoxDecoration(
                      color: const Color(0xFF237ABA).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: TextButton(
                      onPressed: () {

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFFFFF),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}