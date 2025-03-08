// ignore_for_file: unnecessary_import, file_names, deprecated_member_use, use_build_context_synchronously

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//main class

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
//controllers for the textfields
class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedGender = 'Male';
  final List<String> genders = ['Male', 'Female', 'Other'];
  bool _showPassword = false;
  late AnimationController _animController;
  bool _isLoading = false;
  String _registrationStatus = '';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
  }

  @override
  void dispose() {
    _animController.dispose();
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }
//main build function with the widget
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF1565C0), Color(0xFF0D47A1)],
            stops: [0.2, 0.6, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeInDown(
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          'Create Account',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //main form
                  const SizedBox(height: 32),
                  FadeInUp(
                    child: _buildTextField(
                      controller: nameController,
                      hint: 'Full Name',
                      icon: Icons.person_outline,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: ageController,
                            hint: 'Age',
                            icon: Icons.calendar_today,
                            keyboard: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildGenderDropdown(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: _buildTextField(
                      controller: emailController,
                      hint: 'Email',
                      icon: Icons.email_outlined,
                      keyboard: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: _buildTextField(
                      controller: mobileController,
                      hint: 'Mobile Number',
                      icon: Icons.phone_outlined,
                      keyboard: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: _buildTextField(
                      controller: passwordController,
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: _buildRegisterButton(),
                  ),
                  if (_registrationStatus.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        _registrationStatus,
                        style: GoogleFonts.poppins(
                          color: _registrationStatus == 'Registered Successfully!' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
//text frileds deisgn with a cool animation
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboard = TextInputType.text,
  }) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: controller,
          obscureText: isPassword && !_showPassword,
          keyboardType: keyboard,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.white70),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                    onPressed: () => setState(() => _showPassword = !_showPassword),
                  )
                : null,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      );
//menu options for gender select
  Widget _buildGenderDropdown() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedGender,
            dropdownColor: const Color(0xFF1565C0),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
            isExpanded: true,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            items: genders
                .map((String gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    ))
                .toList(),
            onChanged: (String? value) => setState(() => selectedGender = value!),
          ),
        ),
      );
//register button with a loading animation and go to dashboard after registration
  Widget _buildRegisterButton() => GestureDetector(
        onTapDown: (_) => _animController.forward(),
        onTapUp: (_) => _animController.reverse(),
        onTapCancel: () => _animController.reverse(),
        child: AnimatedBuilder(
          animation: _animController,
          builder: (_, child) => Transform.scale(
            scale: 1 - (_animController.value * 0.05),
            child: child,
          ),
          child: Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0.95)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: TextButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                  _registrationStatus = ''; // Clear previous status
                });
                try {
                  // 1. Create user with email and password
                  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );

                  // 2. Get the user's UID
                  final uid = credential.user!.uid;

                  // 3. Store additional user data in Firestore
                  await FirebaseFirestore.instance.collection('users').doc(uid).set({
                    'uid': uid,
                    'name': nameController.text.trim(),
                    'age': int.tryParse(ageController.text.trim()) ?? 0,
                    'email': emailController.text.trim(),
                    'mobile': mobileController.text.trim(),
                    'gender': selectedGender,
                  });

                  setState(() {
                    _isLoading = false;
                    _registrationStatus = 'Registered Successfully!';
                  });

                  // Navigate to login page after 2 seconds
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pushReplacementNamed(context, '/login'); 
                  });
                } on FirebaseAuthException catch (e) {
                  // Handle Firebase Auth errors (e.g., email already in use, weak password)
                  setState(() {
                    _isLoading = false;
                    _registrationStatus = 'Registration failed: ${e.message}';
                  });
                } catch (e) {
                  // Handle other errors (e.g., Firestore errors)
                  setState(() {
                    _isLoading = false;
                    _registrationStatus = 'An unexpected error occurred: $e';
                  });
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
                      ),
                    )
                  : Text(
                      'Register',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF1565C0),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      );
}