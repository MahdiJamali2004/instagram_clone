import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/components/extensions.dart';
import 'package:instagram_clone/features/auth/presentation/components/my_button.dart';
import 'package:instagram_clone/features/auth/presentation/components/my_text_field.dart';
import 'package:instagram_clone/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:instagram_clone/gen/fonts.gen.dart';

class RegisterPage extends StatefulWidget {
  final void Function() toggleAuthPages;
  const RegisterPage({super.key, required this.toggleAuthPages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late final authCubit = context.read<AuthCubit>();

  void register() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        usernameController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      if (passwordController.text != confirmPasswordController.text) {
        context.showCustomSnackBar(
            'Passwords do not match. Please make sure both fields are the same');
      } else {
        await authCubit
            .register(emailController.text, passwordController.text,
                usernameController.text)
            .onError(
          (error, stackTrace) {
            if (mounted) {
              context.showCustomSnackBar(error.toString());
            }
          },
        ).whenComplete(
          () async {
            if (mounted) {
              context.showCustomSnackBar('registerd succesfully');
            }
          },
        );
      }
    } else {
      context.showCustomSnackBar('Please fill in all fields before proceeding');
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                    child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                  size: 160,
                )),

                //welcome text
                Center(
                  child: Text(
                    'Create an account to get started!',
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

                //usernameHint
                Text(
                  'Username',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                      fontFamily: FontFamily.oswald,
                      fontSize: 16),
                ),
                //usernamefiel
                MyTextField(obscureText: false, controller: usernameController),

                const SizedBox(
                  height: 25,
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
                  height: 25,
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
                  height: 25,
                ),
                //passwrodConfrimHint
                Text(
                  'Confrim Password',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                      fontFamily: FontFamily.oswald,
                      fontSize: 16),
                ),
                //confirmpasswordfiel
                MyTextField(
                    obscureText: true, controller: confirmPasswordController),

                const SizedBox(
                  height: 80,
                ),

                //loginButtotn
                MyButton(
                  text: 'Register',
                  onTap: register,
                ),
                const SizedBox(
                  height: 20,
                ),
                //createAccountButton
                Center(
                  child: TextButton(
                    onPressed: widget.toggleAuthPages,
                    child: Text(
                      'Already have an Account?',
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
