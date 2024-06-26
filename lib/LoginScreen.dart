import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:login_with_firebase_part7/HomeScreen.dart';
import 'package:login_with_firebase_part7/RegisterScreen.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();

  checkBio() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
  }

  checkUserIsLoginOrNot() async {
    bool isLogin = await _googleSignIn.isSignedIn();
    if (isLogin) {
      try {
        final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Please authenticate to login',
            options: const AuthenticationOptions(useErrorDialogs: false));
        if(didAuthenticate){
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
                return const HomeScreen();
              }), (route) => false);
        }
      } on PlatformException catch (e) {
        if (e.code == auth_error.notEnrolled) {
         Fluttertoast.showToast(msg: e.message??"1");
        } else if (e.code == auth_error.lockedOut ||
            e.code == auth_error.permanentlyLockedOut) {
          Fluttertoast.showToast(msg: e.message??"2");
        } else {
          Fluttertoast.showToast(msg: e.message??"3");
        }
      }
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential;
    } else {
      print("Google Sign-in cancelled");
      return null;
    }
  }

  Future<UserCredential?> signInWithPassword() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.code);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserIsLoginOrNot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  label: Text('Email'),
                ),
                controller: email,
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                decoration: InputDecoration(
                  label: Text('Password'),
                ),
                controller: password,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    UserCredential? user = await signInWithPassword();
                    if (user?.user != null) {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return const HomeScreen();
                      }), (route) => false);
                    }
                  },
                  child: const Text("Login With Email")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RegisterScreen();
                    }));
                  },
                  child: const Text("Register With Email")),
              ElevatedButton(
                  onPressed: () async {
                    UserCredential? user = await signInWithGoogle();
                    if (user?.user != null) {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return const HomeScreen();
                      }), (route) => false);
                    }
                  },
                  child: const Text("Login With Google")),
            ],
          ),
        ),
      ),
    );
  }
}
