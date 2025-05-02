import 'package:flutter/material.dart';
import 'package:health_care_app/auth/form_container.dart';
import 'package:health_care_app/services/auth_service.dart';
import 'package:health_care_app/widgets/rectangular_button.dart';
import 'package:health_care_app/main.dart';
import 'package:health_care_app/widgets/input_dialog.dart';
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
  TextEditingController remindEmail = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    remindEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FormContainer(
      title: "Login",
      children: [
        TextInputForm(
          key: Key('emailField'),
          width: size.width * 0.9,
          hint: 'E-mail',
          controller: email,
          iconData: Icons.person,
        ),
        const SizedBox(height: 15),
        TextInputForm(
          key: Key('passwordField'),
          width: size.width * 0.9,
          hint: 'Password',
          controller: password,
          hideText: true,
          iconData: Icons.lock,
        ),
        const SizedBox(height: 15),
        RectangularButton(
          title: "LOGIN",
          isLoading: isLoading,
          onPressed: () async {
            String userEmail = email.text;
            String userPassword = password.text;

            try {
              setState(() => isLoading = true);
              final authService = AuthService();
              await authService.signIn(userEmail, userPassword);
              setState(() => isLoading = false);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            } catch (e) {
              setState(() => isLoading = false);
              displayErrorMotionToast('Failed to log in.', context);
            }
          },
        ),
        const SizedBox(height: 15),
        MyTextButton(
          onPressed: changePassword,
          title: 'Forgot your password?',
          textPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  // reset password
  Future<void> resetPassword(String email) async {
    final authService = AuthService();
    return await authService.resetPassword(email);
  }

  // change password function
  void changePassword() {
    remindEmail.clear();
    showDialog<String>(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Builder(
              builder: (context) {
                return InputDialog(
                  controller: remindEmail,
                  title: 'Forgot your password? Don\'t worry!',
                  hint: 'E-mail',
                  iconData: Icons.person,
                  button: RectangularButton(
                    title: "Confirm",
                    isLoading: isLoading,
                    onPressed: () async {
                      String userEmail = remindEmail.text;
                      try {
                        await resetPassword(userEmail);
                        Navigator.of(context).pop();
                        displaySuccessMotionToast('Email was sent.', context);
                      } catch (e) {
                        displayErrorMotionToast(
                          'Failed to send email.',
                          context,
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
    );
  }
}
