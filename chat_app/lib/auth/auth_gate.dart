import 'package:chat_app/auth/login_or_register_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// check if user is logged in or not
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return const HomePage();
          }
          // user is not logged in
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
