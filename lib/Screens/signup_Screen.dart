import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_ship/Screens/login_Screen.dart';
import 'package:safe_ship/Widgets/custom_form_field.dart';
import 'package:safe_ship/Widgets/navigation_widget.dart';
import 'package:safe_ship/main.dart';
import 'home_screen.dart';
import '../Riverpod/auth_provider.dart';

class SignupScreen extends ConsumerWidget {
  SignupScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _personNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider.notifier);
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        color: Colors.purpleAccent.withOpacity(0.2),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                return Form(
                  key: _formKey,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,

                        child: Transform.scale(
                          scale: 1.7,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 600),
                            width: 120,
                            height: 120,
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
                            duration: Duration(milliseconds: 600),
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(200)),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/register.png'),
                                CustomFormField(
                                  controller: _personNameController,
                                  hintText: 'Name',
                                  obscureText: false,
                                  keyboardType: TextInputType.name,
                                  validatorType: 'name',
                                  iconsType: Icons.person,
                                ),
                                const SizedBox(height: 16),
                                CustomFormField(
                                  controller: _ageController,
                                  hintText: "Age",
                                  obscureText: false,
                                  keyboardType: TextInputType.number,
                                  validatorType: 'age',
                                  iconsType: Icons.numbers,
                                ),
                                const SizedBox(height: 16),
                                CustomFormField(
                                  controller: _emailController,
                                  hintText: 'Email',
                                  obscureText: false,
                                  keyboardType: TextInputType.emailAddress,
                                  validatorType: 'email',
                                  iconsType: Icons.email,
                                ),
                                const SizedBox(height: 16),
                                CustomFormField(
                                  controller: _passwordController,
                                  hintText: 'Password',
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  validatorType: 'password',
                                  iconsType: Icons.lock,
                                ),
                                const SizedBox(height: 24),
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
                                          width:
                                              width * 0.9, // Responsive width
                                          decoration: BoxDecoration(
                                            color: Colors.purple,
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Sign Up',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          if (_formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            authNotifier
                                                .signupUserWithFirebase(
                                              _emailController.text,
                                              _passwordController.text,
                                              _personNameController.text,
                                              _ageController.text,
                                            )
                                            // authNotifier
                                            //     .sendEmailVerificationLink()
                                                .then((_) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Container(
                                                    padding:
                                                    const EdgeInsets.all(1),
                                                    height: 50,
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    decoration:
                                                    const BoxDecoration(
                                                      color: Colors.greenAccent,
                                                      borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: const Row(
                                                      children: [
                                                        SizedBox(width: 8),
                                                        Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 40,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Expanded(
                                                          child: Center(
                                                            child: Text(
                                                              'A verification email has been sent to you mail, please verify the email and login again!!!',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
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

                                              context.navigateToScreen(
                                                isReplace: true,
                                                child: MyApp(),
                                              );

                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Container(
                                                  padding:
                                                      const EdgeInsets.all(1),
                                                  height: 50,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.redAccent,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
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
                                                                color: Colors
                                                                    .white),
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
                                const SizedBox(height: 24),
                                GestureDetector(
                                  child: const Text(
                                    'Already a User? Login',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onTap: () {
                                    context.navigateToScreen(
                                        isReplace: true, child: LoginScreen());
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
