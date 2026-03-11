import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_app/controllers/auth_controller.dart';
//  import 'package:qr_app/core/routes.dart';
import 'package:qr_app/utils/const.dart';
import 'package:qr_app/utils/helper.dart';
import 'package:qr_app/utils/validator.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.08),
              colorScheme.surface,
              colorScheme.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
              child: Obx(
                () => Form(
                  key: _controller.registerFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo / Icon area
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.qr_code_rounded,
                            color: colorScheme.onPrimary,
                            size: 42,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Title
                      Text(
                        "Welcome to",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        Const.appName,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Register to make an account',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Card container
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 30,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: colorScheme.outline.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Name field
                            _FieldLabel(label: 'Full Name'),
                            const SizedBox(height: 8),
                            TextFormField(
                              validator: Validator.validateName,
                              controller: _controller.nameController,
                              decoration: _inputDecoration(
                                context,
                                hint: 'John Doe',
                                prefixIcon: Icons.person_outline_rounded,
                              ),
                              onTapOutside: Helper.onTapOutside,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              autofillHints: const [AutofillHints.name],
                            ),

                            const SizedBox(height: 20),

                            // Email field
                            _FieldLabel(label: 'Email Address'),
                            const SizedBox(height: 8),
                            TextFormField(
                              validator: Validator.validateEmail,
                              controller: _controller.emailController,
                              decoration: _inputDecoration(
                                context,
                                hint: 'you@example.com',
                                prefixIcon: Icons.email_outlined,
                              ),
                              onTapOutside: Helper.onTapOutside,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                            ),

                            const SizedBox(height: 20),

                            // Password field
                            _FieldLabel(label: 'Password'),
                            const SizedBox(height: 8),
                            TextFormField(
                              validator: Validator.validatePassword,
                              controller: _controller.passwordController,
                              obscureText: _controller.isObscure.value,
                              decoration: _inputDecoration(
                                context,
                                hint: '••••••••',
                                prefixIcon: Icons.lock_outline_rounded,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _controller.isObscure.value
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                    color: colorScheme.onSurface.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                  onPressed: _controller.toggleObscure,
                                ),
                              ),
                              onTapOutside: Helper.onTapOutside,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.visiblePassword,
                              autofillHints: const [AutofillHints.password],
                            ),

                            const SizedBox(height: 20),

                            // Confirm Password field
                            _FieldLabel(label: 'Confirm Password'),
                            const SizedBox(height: 8),
                            TextFormField(
                              validator: (value) =>
                                  Validator.validateConfirmPassword(
                                    value,
                                    _controller.passwordController.text,
                                  ),
                              controller: _controller.confirmPasswordController,
                              obscureText: _controller.isObscureConfirm.value,
                              decoration: _inputDecoration(
                                context,
                                hint: '••••••••',
                                prefixIcon: Icons.lock_outline_rounded,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _controller.isObscureConfirm.value
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                    color: colorScheme.onSurface.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                  onPressed: _controller.toggleObscureConfirm,
                                ),
                              ),
                              onTapOutside: Helper.onTapOutside,
                              textInputAction: TextInputAction.send,
                              keyboardType: TextInputType.visiblePassword,
                              autofillHints: const [AutofillHints.password],
                            ),

                            const SizedBox(height: 28),

                            // Register Button
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _controller.isLoading.value
                                    ? null
                                    : _controller.register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  disabledBackgroundColor: colorScheme.primary
                                      .withOpacity(0.5),
                                  elevation: _controller.isLoading.value
                                      ? 0
                                      : 4,
                                  shadowColor: colorScheme.primary.withOpacity(
                                    0.4,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: _controller.isLoading.value
                                    ? SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: colorScheme.onPrimary,
                                        ),
                                      )
                                    : Text(
                                        'Register',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: colorScheme.onPrimary,
                                              letterSpacing: 0.3,
                                            ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Login link
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Already have an account? ",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(
                                    0.55,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: 'Login',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w700,
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
      ),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        prefixIcon,
        color: colorScheme.primary.withOpacity(0.7),
        size: 20,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: colorScheme.primary.withOpacity(0.04),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
      ),
    );
  }
}
