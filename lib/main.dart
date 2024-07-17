import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tasks/Home.dart';
import 'package:tasks/login.dart';
import 'package:tasks/register.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      locale: Locale('AR', 'OM'),
      debugShowCheckedModeBanner: false,
      home: RegisterPage(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser == null
        ? Scaffold(
            appBar: AppBar(
              title: Text('تسجيل الدخول'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          var user = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: 'khalifa8157@moe.om',
                                  password: '12345678');
                          print(user.user!.email);
                          // final userCredential =
                          //     await FirebaseAuth.instance.signInAnonymously();

                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => const Home(),
                          //   ),
                          // );
                          // print("Signed in with temporary account.");
                        } on FirebaseAuthException catch (e) {
                          switch (e.code) {
                            case "operation-not-allowed":
                              print(
                                  "Anonymous auth hasn't been enabled for this project.");
                              break;
                            default:
                              print("Unknown error.");
                          }
                        }
                      },
                      child: Text('تسجيل الدخول')),
                ],
              ),
            ))
        : Home();
  }
}
