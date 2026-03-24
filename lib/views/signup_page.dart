import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/signup_controller.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController c = Get.put(SignupController());

    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        title: const Text(
          "Create Account",
          style: TextStyle(
            color: Color.fromARGB(255, 50, 63, 6),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Logo
              Image.asset('assets/logog.jpg', height: 150),
              const SizedBox(height: 10),

              // Tagline
              Text(
                'Join the Great Coffee family ☕',
                style: TextStyle(
                  color: Colors.brown[600],
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),

              // Full Name
              _label("Full Name"),
              _textField(
                controller: c.nameController,
                hint: "Enter your full name",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              // Email
              _label("Email Address"),
              _textField(
                controller: c.emailController,
                hint: "Enter your email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Phone
              _label("Phone Number"),
              _textField(
                controller: c.phoneController,
                hint: "e.g. 0712345678",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Password
              _label("Password"),
              Obx(
                () => _textField(
                  controller: c.passwordController,
                  hint: "Min. 6 characters",
                  icon: Icons.lock_outline,
                  obscureText: !c.isPassVisible.value,
                  suffixIcon: GestureDetector(
                    onTap: c.togglePassword,
                    child: Icon(
                      c.isPassVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.brown[400],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Confirm Password
              _label("Confirm Password"),
              Obx(
                () => _textField(
                  controller: c.confirmPasswordController,
                  hint: "Re-enter your password",
                  icon: Icons.lock_outline,
                  obscureText: !c.isConfirmPassVisible.value,
                  suffixIcon: GestureDetector(
                    onTap: c.toggleConfirmPassword,
                    child: Icon(
                      c.isConfirmPassVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.brown[400],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Sign Up Button
              Obx(
                () => c.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.amber)
                    : GestureDetector(
                        onTap: () async {
                          bool success = await c.signup();
                          if (success) Get.offAllNamed('/');
                        },
                        child: Container(
                          height: 52,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Text(
                            "Create Account",
                            style: TextStyle(
                              color: Color.fromARGB(255, 50, 63, 6),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 24),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.brown[600]),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.red[500],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ── Reusable label widget ────────────────────────
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    ),
  );

  // ── Reusable text field widget ───────────────────
  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.brown[400]),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.amber.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.amber, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    ),
  );
}
