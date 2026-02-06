import 'package:flutter/material.dart';
import '../../ui/screens/login_screen.dart';
import '../../ui/screens/request_submitted_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _nationalIdController = TextEditingController();

  bool _isLoading = false;
  bool _isFormValid = false;

  late AnimationController _animationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _field1Animation;
  late Animation<double> _field2Animation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _nationalIdController.addListener(_validateForm);

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Staggered animations for each element
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.4, curve: Curves.easeOut),
      ),
    );

    _field1Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    _field2Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );

    // Start animation
    _animationController.forward();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _emailController.text.isNotEmpty &&
          _nationalIdController.text.isNotEmpty;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate password reset API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    // Navigate to request submitted screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RequestSubmittedScreen()),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              right: -50,
              top: 150,
              child: Image.asset(
                'assets/images/rectangle3.png',
                width: 400,
                fit: BoxFit.contain,
              ),
            ),
            // Main content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),

                        // UniNexus Logo
                        FadeTransition(
                          opacity: _logoAnimation,
                          child: ScaleTransition(
                            scale: _logoAnimation,
                            child: Image.asset(
                              'assets/images/logonew.png',
                              width: 80,
                              height: 80,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        FadeTransition(
                          opacity: _titleAnimation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(_titleAnimation),
                            child: const Text(
                              'Forgotten Password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color(0xFF000000),
                                height: 1.3,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        FadeTransition(
                          opacity: _titleAnimation,
                          child: const Text(
                            'Enter your details to renew your credentials',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xFF666666),
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Email / ID Field
                        FadeTransition(
                          opacity: _field1Animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(-0.3, 0),
                              end: Offset.zero,
                            ).animate(_field1Animation),
                            child: _buildTextField(
                              controller: _emailController,
                              label: 'Email / ID',
                              hintText: 'Enter Your Email/ID',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // National ID Field
                        FadeTransition(
                          opacity: _field2Animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(-0.3, 0),
                              end: Offset.zero,
                            ).animate(_field2Animation),
                            child: _buildTextField(
                              controller: _nationalIdController,
                              label: 'National ID',
                              hintText: 'Enter Your National ID',
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Submit Button
                        FadeTransition(
                          opacity: _buttonAnimation,
                          child: ScaleTransition(
                            scale: _buttonAnimation,
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF7B76CF), // violet
                                    Color(0xFF69CFD8), // cyan
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: ElevatedButton(
                                onPressed: _isFormValid && !_isLoading
                                    ? _handleSubmit
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  disabledBackgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                                    : const Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF000000),
            ),
          ),
        ),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(28),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF000000),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFFBBBBBB),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}