import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_ship/Widgets/custom_form_field.dart';

import '../Riverpod/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider.notifier);
    final TextEditingController _forgotPasswordController =
        TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.purple.withOpacity(0.4),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        curve: Curves.easeIn,
        color: Colors.purple.withOpacity(0.2),
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: Transform.scale(
                  scale: 2,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 600),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(200)),
                  ),
                )),
            Align(
                alignment: Alignment.topLeft,
                child: Transform.scale(
                  scale: 2,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 600),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(200)),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/Forgot_password.png',
                    width: 350,
                    height: 350,
                  ),
                  const Text(
                    "Enter email to send you a password reset email",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  CustomFormField(
                      controller: _forgotPasswordController,
                      hintText: "Email",
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      validatorType: 'email',
                      iconsType: Icons.email),
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
                            width: MediaQuery.sizeOf(context).width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Center(
                              child: Text(
                                'Send',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            FocusScope.of(context).unfocus();
                            if (_forgotPasswordController.text.isEmpty) {
                              return;
                            } else {
                              await authNotifier.sendPasswordResetLink(
                                  _forgotPasswordController.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Container(
                                    padding: const EdgeInsets.all(1),
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: const BoxDecoration(
                                      color: Colors.lightGreen,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              'An email for password reset has been sent to your mail',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  elevation: 20,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
