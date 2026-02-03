import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uninexus/ui/screens/SignUp_Screen.dart';
import '../../ui/screens/ForgetPassword_Screen.dart';
import 'dashboard_screen.dart';
import 'faculty_home_screen.dart';
import 'stu_home.dart';
import '../../services/firebase/login_service.dart';

// SharedPreferences Keys
const String _kRememberMeKey = 'rememberMe';
const String _kUserCodeKey = 'userCode';
const String _kUserTypeKey = 'userType';

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
  bool _rememberMe = true;
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

  /// Checks if a session exists and navigates automatically
  Future<void> _checkLoggedInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_kRememberMeKey) ?? false;
    final userCode = prefs.getString(_kUserCodeKey);

    setState(() {
      _rememberMe = rememberMe;
    });

    if (rememberMe && userCode != null && mounted) {
      // Accessing individual keys to pass to the next screen
      final firstName = prefs.getString('fName') ?? '';
      final lastName = prefs.getString('lName') ?? '';
      _navigateToScreen(userCode, firstName: firstName, lastName: lastName);
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _codeController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
      _errorMessage = null;
    });
  }

  /// Navigates to the correct home screen based on ID prefix
  void _navigateToScreen(String code, {String? firstName, String? lastName}) {
    if (!mounted) return;

    final prefix = code.substring(0, 2).toUpperCase();

    if (prefix == 'ST') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StuHomeScreen()),
      );
    } else if (prefix == 'FA') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FacultyHomeScreen(
            firstName: firstName ?? "Faculty",
            lastName: lastName ?? "",
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  /// Saves EVERY field from the model map as an individual key in SharedPreferences
  // Inside login_screen.dart -> _LoginScreenState

  Future<void> _saveLoginData(Map<String, dynamic> userData, UserType type) async {
    final prefs = await SharedPreferences.getInstance();

      // 1. Save the ID and UserType for routing
      await prefs.setString('ID', userData['ID'] ?? '');
      await prefs.setString('userType', type.toString());

      // 2. Loop through EVERY variable in the Firestore data
      for (var entry in userData.entries) {
        final String key = entry.key;
        final dynamic value = entry.value;

        if (value == null) continue;

        if (value is String) {
          await prefs.setString(key, value);
        } else if (value is int) {
          await prefs.setInt(key, value);
        } else if (value is bool) {
          await prefs.setBool(key, value);
        } else if (value is List) {
          // Specifically handles "subjects" or "workDays" lists
          await prefs.setStringList(key, value.map((e) => e.toString()).toList());
        }
      }
      if (!_rememberMe){
      await prefs.setBool('rememberMe', false);
      }
      else{
        await prefs.setBool('rememberMe', _rememberMe);
      }
  }

// Update your handle login navigation call:
  Future<void> _handleLogin() async {
    if (!_isFormValid) return;
    setState(() => _isLoading = true);

    final result = await _loginService.login(_codeController.text, _passwordController.text);
    final status = result['status'] as LoginResult;

    if (status == LoginResult.success) {
      final userData = result['userData'] as Map<String, dynamic>;
      final userType = result['userType'] as UserType;

      await _saveLoginData(userData, userType);

      _navigateToScreen(
        userData['ID'] ?? '',
        firstName: userData['fName'] ?? '',
        lastName: userData['lName'] ?? '',
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = _getErrorMessage(status);
      });
    }
  }

  String _getErrorMessage(LoginResult status) {
    switch (status) {
      case LoginResult.userNotFound: return 'User not found.';
      case LoginResult.passwordMismatch: return 'Invalid credentials.';
      case LoginResult.signUpRequired: return 'Please sign up in the app first.';
      case LoginResult.invalidPrefix: return 'Invalid ID format.';
      case LoginResult.error: return 'Connection error.';
      default: return 'Login failed.';
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
        body: Center(child: CircularProgressIndicator(color: Color(0xFF237ABA))),
      );
    }

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
                  const Text(
                    'Welcome Back',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Color(0xFF0A4C7D)),
                  ),
                  const SizedBox(height: 40),

                  // Input Fields
                  _buildTextField(controller: _codeController, hintText: 'Code'),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    isPassword: true,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),

                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (v) => setState(() => _rememberMe = v ?? false),
                            activeColor: const Color(0xFF4FC3DC),
                          ),
                          const Text('Remember me', style: TextStyle(color: Color(0xFF0A4C7D))),
                        ],
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const ForgotPasswordScreen())),
                        child: const Text('Forgot Password', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isFormValid ? _handleLogin : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF237ABA),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const SignUpScreen())),
                        child: const Text('Sign up', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color(0xFF0A4C7D)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 22, color: Color(0xFF0A4C7D)),
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}