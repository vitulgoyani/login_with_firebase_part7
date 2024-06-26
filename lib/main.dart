import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_with_firebase_part7/LoginScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBOJLVgX2oMRSm-ws9rxLAD1YFzTlBMfNQ",
          authDomain: "authentication-demo-8d328.firebaseapp.com",
          projectId: "authentication-demo-8d328",
          storageBucket: "authentication-demo-8d328.appspot.com",
          messagingSenderId: "153765246896",
          appId: "1:153765246896:web:ad735121abe0084748c875",
          measurementId: "G-1EQSXT1MXW"
      ));
      runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
