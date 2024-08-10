import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_ship/Screens/home_screen.dart';
import 'package:safe_ship/Screens/login_Screen.dart';
import 'package:safe_ship/Widgets/navigation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLoad();
  }

  Future<void> _checkFirstLoad() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      // It's the first time the app is loaded
      setState(() {
        isFirstLoad = true;
      });
      await prefs.setBool('isFirstTime', false);
    } else {
      // Subsequent loads
      setState(() {
        isFirstLoad = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isFirstLoad
          ? LoginScreen() // Show onboarding or special initial screen
          : StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          } else {
            final user = snapshot.data;
            if (user == null) {
              return LoginScreen();
            } else {
              if (user.emailVerified) {
                return HomeScreen();
              } else {
                return VerifyEmailScreen();
              }
            }
          }
        },
      ),
    );
  }
}

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (timer){
      FirebaseAuth.instance.currentUser?.reload();
      if(FirebaseAuth.instance.currentUser!.emailVerified == true){
        timer.cancel();
        context.navigateToScreen(isReplace: true,child: MyApp());
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
        color: Colors.purpleAccent.withOpacity(0.2),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/Forgot_password.png'),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(child: Text("A verification email has been sent to your email address. Please verify to continue.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                child: Container(
                  height: 50,
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius:
                    BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      'Resend Email Verification',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                onTap: ()async {
                  User? user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Verification email resent!"),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                child: Container(
                  height: 50,
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius:
                    BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      'Back to login ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                onTap: (){
                  context.navigateToScreen(isReplace:true,child: LoginScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
