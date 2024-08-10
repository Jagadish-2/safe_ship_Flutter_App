import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_ship/Screens/forgot_password_screen.dart';
import 'package:safe_ship/Screens/signup_Screen.dart';
import 'package:safe_ship/Widgets/navigation_widget.dart';

import '../Riverpod/auth_provider.dart';
import '../Widgets/custom_form_field.dart';
import 'home_screen.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider.notifier);
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
        color: Colors.purpleAccent.withOpacity(0.2),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Transform.scale(
                    scale: 1.7,
                    child: AnimatedContainer(
                      curve: Curves.easeIn,
                      duration: Duration(milliseconds: 600),
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(200)),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Transform.scale(
                    scale: 1.7,
                    child: AnimatedContainer(
                      curve: Curves.easeIn,
                      duration: Duration(milliseconds: 600),
                      height: 115,
                      width: 115,
                      decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(200)),
                    ),
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/login.png',
                              ),
                              CustomFormField(
                                controller: _emailController,
                                hintText: 'Email',
                                obscureText: false,
                                iconsType: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validatorType: 'email',
                              ),
                              const SizedBox(height: 20),
                              CustomFormField(
                                controller: _passwordController,
                                hintText: 'Password',
                                obscureText: true,
                                iconsType: Icons.lock,
                                keyboardType: TextInputType.visiblePassword,
                                validatorType: 'password',
                              ),
                              const SizedBox(height: 20),
                              authNotifier.isLoading
                                  ? const Center(
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : InkWell(
                                      child: Container(
                                        height: 50,
                                        width: constraints.maxWidth * 0.9,
                                        decoration: BoxDecoration(
                                          color: Colors.purple,
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          authNotifier
                                              .loginUserWithFirebase(
                                            _emailController.text,
                                            _passwordController.text,
                                          )
                                              .then((_) {
                                            context.navigateToScreen(
                                              isReplace: true,
                                              child: HomeScreen(),
                                            );
                                          });
                                        } else {
                                          // Show error message
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Container(
                                                padding:
                                                    const EdgeInsets.all(1),
                                                height: 80,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: const BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(15),
                                                  ),
                                                ),
                                                child: const Row(
                                                  children: [
                                                    SizedBox(width: 8),
                                                    Icon(
                                                      Icons.warning,
                                                      color: Colors.white,
                                                      size: 40,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                      child: Center(
                                                        child: Text(
                                                          'Please fix the errors in red before submitting.',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 20,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                              const SizedBox(height: 15),
                              InkWell(
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Forgot password',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  context.navigateToScreen(
                                      child: const ForgotPasswordScreen());
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: GestureDetector(
                                  child: const Text(
                                    'A New User?  Sign up Instead',
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                                  ),
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    context.navigateToScreen(
                                      isReplace: true,
                                      child: SignupScreen(),
                                    );
                                  },
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
            );
          },
        ),
      ),
    );
  }
}
