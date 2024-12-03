import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/screens/log_in_screen.dart';
import 'package:notes/screens/notes_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      _checkAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // backgroundColor: Color.fromRGBO(37, 37, 37, 1),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  void _checkAuth() {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
      if (user == null) {
        return const LoginScreen();
      }
      return const NotesScreen();
    }));
  }
}
