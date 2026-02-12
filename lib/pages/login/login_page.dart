import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  final LoginController _loginController = Get.put(LoginController());

  LoginPage({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralColor,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                const MyText(
                  text: 'Welcome Back!',
                  fontsize: 26,
                  color: textColor,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                  fontfamily: 'poppins',
                ),
                const SizedBox(height: 10),
                SvgPicture.asset(
                  'assets/svg/login_vector.svg',
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 20),
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
                        decoration: _buildInputDecoration(
                            'username', Icons.person_outline),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _loginController.passwordController,
                        obscureText: true,
                        decoration: _buildInputDecoration(
                            'password', Icons.lock_outline),
                      ),
                      const SizedBox(height: 16),
                      _buildRememberAndForgotRow(),
                      const SizedBox(height: 10),
                      _buildDividerWithText(),
                      const SizedBox(height: 10),
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
      hintStyle: GoogleFonts.poppins(fontWeight: FontWeight.w200, fontSize: 14),
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
                  onChanged: (value) =>
                      _loginController.rememberMe.value = value ?? false,
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
            'please sign in',
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
                ? const CircularProgressIndicator(color: Colors.black87)
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
