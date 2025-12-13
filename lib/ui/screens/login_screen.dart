// login_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // REQUIRED
import 'package:uninexus/ui/screens/SignUp_Screen.dart';
import '../../ui/screens/ForgetPassword_Screen.dart';
import 'dashboard_screen.dart';
import 'stu_home.dart';
import '../../services/firebase/login_service.dart';

// Keys for SharedPreferences
const String _kRememberMeKey = 'rememberMe';
const String _kUserCodeKey = 'userCode';
const String _kUserFirstNameKey = 'userFirstName'; // <<< NEW KEY
const String _kUserLastNameKey = 'userLastName';  // <<< NEW KEY

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginService = LoginService();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = true;
  bool _isFormValid = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _checkLoggedInStatus();
  }

  // Helper to check for saved login status and navigate if found
  Future<void> _checkLoggedInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_kRememberMeKey) ?? false;
    final userCode = prefs.getString(_kUserCodeKey);

    // Set rememberMe state from saved preference
    _rememberMe = rememberMe;

    if (rememberMe && userCode != null && mounted) {
      // If remembered, navigate immediately
      _navigateToScreen(userCode);
    } else {
      setState(() {
        _isLoading = false; // Allow user to interact with the form
      });
    }
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _codeController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
      _errorMessage = null;
    });
  }

  // Consolidated navigation logic
  void _navigateToScreen(String code) {
    if (!mounted) return;

    if (_isStudentPrefix(code)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StuHomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  // Only returns true for the 'ST' prefix
  bool _isStudentPrefix(String code) {
    if (code.length < 2) return false;
    final prefix = code.substring(0, 2).toUpperCase();
    return prefix == 'ST';
  }

  // Function to save user data (UPDATED)
  Future<void> _saveLoginData(String code, String firstName, String lastName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kRememberMeKey, _rememberMe);
    if (_rememberMe) {
      await prefs.setString(_kUserCodeKey, code);
      await prefs.setString(_kUserFirstNameKey, firstName); // <<< SAVE FIRST NAME
      await prefs.setString(_kUserLastNameKey, lastName);   // <<< SAVE LAST NAME
    } else {
      // Clear all if rememberMe is unchecked
      await prefs.remove(_kUserCodeKey);
      await prefs.remove(_kUserFirstNameKey);
      await prefs.remove(_kUserLastNameKey);
    }
  }

  Future<void> _handleLogin() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final code = _codeController.text;
    final password = _passwordController.text;

    final result = await _loginService.login(code, password);

    setState(() {
      _isLoading = false;
    });

    final status = result['status'] as LoginResult;

    if (status == LoginResult.success) {

      // *** ASSUMPTION: LoginService returns 'firstName' and 'lastName' on success
      final firstName = result['firstName'] as String? ?? 'User';
      final lastName = result['lastName'] as String? ?? '';

      // Success: Save preferences based on checkbox state
      await _saveLoginData(code, firstName, lastName); // <<< PASS NAMES TO SAVE

      // Navigate based on prefix
      _navigateToScreen(code);

    } else {
      // Failure: Show appropriate error
      String msg;
      switch (status) {
        case LoginResult.userNotFound:
          msg = 'User not found in database.';
          break;
        case LoginResult.passwordMismatch:
          msg = 'Invalid Code or Password.';
          break;
        case LoginResult.signUpRequired:
          msg = 'Please sign up first to access the app.';
          break;
        case LoginResult.invalidPrefix:
          msg = 'Invalid code prefix (Use ST, FA, IT, SC, AD).';
          break;
        case LoginResult.error:
          msg = 'Connection error. Please try again.';
          break;
        default:
          msg = 'Login failed.';
      }

      setState(() {
        _errorMessage = msg;
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF237ABA)),
        ),
      );
    }

    return Scaffold(
      // ... rest of the build method (kept unchanged)
      body: Container(
        decoration: const BoxDecoration(
          // ... background image decoration
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
                  // Logo
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
                  // Welcome Text
                  const Text(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Color(0xFF0A4C7D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Access your account to explore\nfeatures',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF0A4C7D),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Code Field
                  _buildTextField(
                    controller: _codeController,
                    hintText: 'Code',
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  _buildTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    isPassword: true,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF2D3748).withOpacity(0.5),
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),

                  // Error Message Display
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Remember Me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) => setState(() => _rememberMe = value ?? false),
                            activeColor: const Color(0xFF4FC3DC),
                          ),
                          const Text(
                            'Remember me',
                            style: TextStyle(
                              color: Color(0xFF0A4C7D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                          );
                        },
                        child: const Text('Forgot Password', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isFormValid && !_isLoading ? _handleLogin : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF237ABA),
                        disabledBackgroundColor: const Color(0xFF237ABA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                          : const Text('Login', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(color: Color(0xFF0A4C7D))),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: const Text('Sign up', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ],
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

  // Helper method for text field styling (kept unchanged)
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      width: 369,
      height: 63,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withOpacity(0.75),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color(0xFF0A4C7D), width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 28, color: Color(0xFF0A4C7D)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: const Color(0xFF0A4C7D).withOpacity(0.4), fontSize: 28),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}