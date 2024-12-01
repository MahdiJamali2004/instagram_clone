import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/features/auth/presentation/components/extensions.dart';
import 'package:instagram_clone/features/auth/presentation/components/my_button.dart';
import 'package:instagram_clone/features/auth/presentation/components/my_text_field.dart';
import 'package:instagram_clone/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:instagram_clone/gen/assets.gen.dart';
import 'package:instagram_clone/gen/fonts.gen.dart';

class LoginPage extends StatefulWidget {
  final void Function() toggleAuthPages;
  const LoginPage({super.key, required this.toggleAuthPages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late final authCubit = context.read<AuthCubit>();
  bool isLoading = false;

  void login() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      authCubit
          .login(emailController.text, passwordController.text)
          .whenComplete(
        () {
          setState(() {
            isLoading = false;
          });
        },
      );
    } else {
      context.showCustomSnackBar('Please enter both email and password');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //app icon
                Center(
                  child: SvgPicture.asset(
                    Assets.images.icInstagram,
                    width: 160,
                    height: 160,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.primary,
                        BlendMode.srcATop),
                  ),
                ),
                //welcome text
                Center(
                  child: Text(
                    'Welcome to Instagram Clone',
                    style: TextStyle(
                        fontFamily: FontFamily.oswald,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),

                //emailHint
                Text(
                  'Email',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                      fontFamily: FontFamily.oswald,
                      fontSize: 16),
                ),
                //emailfield
                MyTextField(obscureText: false, controller: emailController),

                const SizedBox(
                  height: 50,
                ),

                //passwordHint
                Text(
                  'Password',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                      fontFamily: FontFamily.oswald,
                      fontSize: 16),
                ),
                //passwrodfield
                MyTextField(obscureText: true, controller: passwordController),

                const SizedBox(
                  height: 80,
                ),

                //loginButtotn
                MyButton(
                  text: 'Login',
                  onTap: () {
                    setState(() {
                      isLoading = true;
                    });
                    login();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                //loadingIndicator
                isLoading == true
                    ? const Center(
                        child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                          color: Colors.blue,
                        ),
                      ))
                    : const SizedBox(),

                //createAccountButton
                Center(
                  child: TextButton(
                    onPressed: widget.toggleAuthPages,
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: FontFamily.oswald,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
