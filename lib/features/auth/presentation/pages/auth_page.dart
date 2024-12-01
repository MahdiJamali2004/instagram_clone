import 'package:flutter/material.dart';
import 'package:instagram_clone/features/auth/presentation/pages/login_page.dart';
import 'package:instagram_clone/features/auth/presentation/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogginPage = true;

  void togglepages() {
    setState(() {
      isLogginPage = !isLogginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogginPage == true
        ? LoginPage(
            toggleAuthPages: togglepages,
          )
        : RegisterPage(
            toggleAuthPages: togglepages,
          );
  }
}
