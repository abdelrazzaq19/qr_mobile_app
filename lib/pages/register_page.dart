import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_app/controllers/auth_controller.dart';
import 'package:qr_app/core/themes.dart';
import 'package:qr_app/utils/const.dart';
import 'package:qr_app/utils/helper.dart';
import 'package:qr_app/utils/validator.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accent.withOpacity(0.07),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Obx(
                  () => Form(
                    key: _controller.registerFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Logo ──────────────────────────────────────────
                        Center(
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.accent.withOpacity(0.35),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.accent.withOpacity(0.15),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.qr_code_rounded,
                              color: AppTheme.accent,
                              size: 36,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        Text(
                          'Welcome to',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPri,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          Const.appName,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.accent,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your account',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            color: AppTheme.textSec,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ── Card ──────────────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppTheme.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Name
                              _Label('Full Name'),
                              const SizedBox(height: 8),
                              TextFormField(
                                validator: Validator.validateName,
                                controller: _controller.nameController,
                                style: const TextStyle(color: AppTheme.textPri),
                                onTapOutside: Helper.onTapOutside,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                autofillHints: const [AutofillHints.name],
                                decoration: _inputDeco(
                                  hint: 'John Doe',
                                  icon: Icons.person_outline_rounded,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Email
                              _Label('Email Address'),
                              const SizedBox(height: 8),
                              TextFormField(
                                validator: Validator.validateEmail,
                                controller: _controller.emailController,
                                style: const TextStyle(color: AppTheme.textPri),
                                onTapOutside: Helper.onTapOutside,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                decoration: _inputDeco(
                                  hint: 'you@example.com',
                                  icon: Icons.alternate_email_rounded,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Password
                              _Label('Password'),
                              const SizedBox(height: 8),
                              TextFormField(
                                validator: Validator.validatePassword,
                                controller: _controller.passwordController,
                                obscureText: _controller.isObscure.value,
                                style: const TextStyle(color: AppTheme.textPri),
                                onTapOutside: Helper.onTapOutside,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.visiblePassword,
                                autofillHints: const [AutofillHints.password],
                                decoration: _inputDeco(
                                  hint: '••••••••',
                                  icon: Icons.lock_outline_rounded,
                                  suffix: IconButton(
                                    icon: Icon(
                                      _controller.isObscure.value
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 18,
                                      color: AppTheme.textSec,
                                    ),
                                    onPressed: _controller.toggleObscure,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Confirm password
                              _Label('Confirm Password'),
                              const SizedBox(height: 8),
                              TextFormField(
                                validator: (v) =>
                                    Validator.validateConfirmPassword(
                                      v,
                                      _controller.passwordController.text,
                                    ),
                                controller:
                                    _controller.confirmPasswordController,
                                obscureText: _controller.isObscureConfirm.value,
                                style: const TextStyle(color: AppTheme.textPri),
                                onTapOutside: Helper.onTapOutside,
                                textInputAction: TextInputAction.send,
                                keyboardType: TextInputType.visiblePassword,
                                autofillHints: const [AutofillHints.password],
                                decoration: _inputDeco(
                                  hint: '••••••••',
                                  icon: Icons.lock_outline_rounded,
                                  suffix: IconButton(
                                    icon: Icon(
                                      _controller.isObscureConfirm.value
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 18,
                                      color: AppTheme.textSec,
                                    ),
                                    onPressed: _controller.toggleObscureConfirm,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 26),

                              // Register button
                              _PrimaryButton(
                                loading: _controller.isLoading.value,
                                label: 'Create Account',
                                onPressed: _controller.register,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 26),

                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Already have an account? ',
                                  style: GoogleFonts.dmSans(
                                    color: AppTheme.textSec,
                                    fontSize: 14,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Sign In',
                                  style: GoogleFonts.dmSans(
                                    color: AppTheme.accent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Get.back(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDeco({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppTheme.textSec),
      prefixIcon: Icon(icon, color: AppTheme.textSec, size: 18),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppTheme.surface2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.danger, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: GoogleFonts.dmSans(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppTheme.textSec,
    ),
  );
}

class _PrimaryButton extends StatelessWidget {
  final bool loading;
  final String label;
  final VoidCallback onPressed;
  const _PrimaryButton({
    required this.loading,
    required this.label,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accent,
          disabledBackgroundColor: AppTheme.accent.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          elevation: 0,
        ),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
