import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_with_firebase_part7/LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          _auth.signOut();
          _googleSignIn.signOut();
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
                return const LoginScreen();
              }), (route) => false);
        },
        child: Text("Logout"),
      )),
    );
  }
}
