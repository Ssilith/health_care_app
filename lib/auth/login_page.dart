// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_care_app/auth/forgot_pass_page.dart';
import 'package:health_care_app/auth/form_container.dart';
import 'package:health_care_app/auth/login_button.dart';
import 'package:health_care_app/main.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:health_care_app/widgets/text_button.dart';
import 'package:health_care_app/widgets/text_input_form.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback callback;
  const LoginPage({super.key, required this.callback});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FormContainer(
      title: "Login",
      children: [
        TextInputForm(
          width: size.width * 0.9,
          hint: 'E-mail',
          controller: email,
          iconData: Icons.person,
        ),
        const SizedBox(height: 15),
        TextInputForm(
          width: size.width * 0.9,
          hint: 'Password',
          controller: password,
          hideText: true,
          iconData: Icons.lock,
        ),
        const SizedBox(height: 15),
        LoginButton(
          title: "LOGIN",
          onPressed: () async {
            String userEmail = email.text;
            String userPassword = password.text;

            try {
              await signIn(userEmail, userPassword);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            } catch (e) {
              displayErrorMotionToast('Failed to log in.', context);
            }
          },
        ),
        const SizedBox(height: 15),
        MyTextButton(
          onPressed:
              () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ForgotPassPage()),
              ),
          title: 'Forgot your password?',
          textPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Future signIn(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
