// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_care_app/auth/login_page.dart';
import 'package:health_care_app/auth/login_page_template.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:health_care_app/widgets/simple_button.dart';
import 'package:health_care_app/widgets/text_input_form.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  TextEditingController email = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
    // LoginPageTemplate(
    //   // title: "Remind password",
    //   // photoUrl: 'assets/undraw_my_password_re_ydq7.svg',
    //   body:
    Column(
      children: [
        TextInputForm(
          width: size.width * 0.9,
          hint: 'E-mail',
          controller: email,
        ),
        const SizedBox(height: 10),
        SimpleButton(
          title: 'Submit',
          textColor: Colors.black,
          onPressed: () async {
            String userEmail = email.text;
            try {
              await resetPassword(userEmail);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginPageTemplate(),
                ),
              );
            } catch (e) {
              displayErrorMotionToast('Failed to send email.', context);
            }
          },
        ),
      ],
      // ),
    );
  }

  Future resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
