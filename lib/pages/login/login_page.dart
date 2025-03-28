import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  final LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                MyText(text: 'Welcome Back!', fontsize: 26, fontfamily: 'poppins', color: textColor, textAlign: TextAlign.center),
                const SizedBox(height: 10),
                SvgPicture.asset(
                  'assets/svg/login_vector.svg',
                  width: 300,
                  height: 300,
                ),
                SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _loginController.emailController,
                        decoration: _buildInputDecoration('username', Icons.person_outline),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _loginController.passwordController,
                        obscureText: true,
                        decoration: _buildInputDecoration('password', Icons.lock_outline),
                      ),
                      const SizedBox(height: 16),
                      _buildRememberAndForgotRow(),
                      const SizedBox(height: 10),
                      _buildDividerWithText(),
                      const SizedBox(height: 10),
                      _buildSocialSignInButtons(),
                      const SizedBox(height: 10),
                      _buildSignInButton(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText, IconData icon) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w200, 
        fontSize: 14
      ),
      suffixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 1),
      ),
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
    );
  }

  Widget _buildRememberAndForgotRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Obx(() => Checkbox(
              value: _loginController.rememberMe.value,
              onChanged: (value) => _loginController.rememberMe.value = value ?? false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            )),
            const SizedBox(width: 1),
            Text(
              'remember me',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
          },
          child: Text(
            'forgot password?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDividerWithText() {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Sign in with',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
        const Expanded(child: Divider(thickness: 1)),
      ],
    );
  }

  Widget _buildSocialSignInButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: IconButton(
            onPressed: () {
            },
            icon: Image.network(
              'https://www.google.com/favicon.ico',
              width: 50,
              height: 50,
            ),
            iconSize: 50,
          ),
        ),
        Container(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: IconButton(
            onPressed: () {
            },
            icon: Icon(Icons.facebook),
            color: Colors.blue[700],
            iconSize: 50,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _loginController.isLoading.value 
          ? null 
          : _loginController.login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue[100],
          foregroundColor: Colors.black87,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: _loginController.isLoading.value
          ? CircularProgressIndicator(color: Colors.black87)
          : Text(
              'Sign In',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
      ),
    ));
  }
}