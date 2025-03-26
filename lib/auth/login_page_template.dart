import 'package:flutter/material.dart';
import 'package:health_care_app/auth/change_view_button.dart';
import 'package:health_care_app/auth/login_page.dart';
import 'package:health_care_app/auth/sign_up_page.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class LoginPageTemplate extends StatefulWidget {
  const LoginPageTemplate({super.key});

  @override
  State<LoginPageTemplate> createState() => _LoginPageTemplateState();
}

class _LoginPageTemplateState extends State<LoginPageTemplate>
    with TickerProviderStateMixin {
  // general animation controller
  late AnimationController animationController;
  // slide out of screen
  late Animation<Offset> slideOutAnimation;
  // slide into screen
  late Animation<Offset> slideInAnimation;
  // gradient controller
  late MeshGradientController _meshController;
  // login or register screen
  bool isLogin = true;

  @override
  void initState() {
    super.initState();
    // gradient decoration
    _meshController = MeshGradientController(
      points: [
        MeshGradientPoint(
          position: const Offset(0.2, 0.6),
          color: const Color.fromARGB(255, 52, 10, 92),
        ),
        MeshGradientPoint(
          position: const Offset(0.4, 0.5),
          color: const Color.fromARGB(255, 119, 90, 224),
        ),
        MeshGradientPoint(
          position: const Offset(0.7, 0.4),
          color: const Color.fromARGB(255, 28, 25, 219),
        ),
        MeshGradientPoint(
          position: const Offset(0.4, 0.9),
          color: const Color.fromARGB(255, 26, 114, 165),
        ),
      ],
      vsync: this,
    );

    // animation duration
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // slide out
    slideOutAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.5, 0.0),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    // slide in
    slideInAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    // change screens
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => isLogin = !isLogin);
        animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    // _meshController.dispose();
    animationController.dispose();
    super.dispose();
  }

  // run animation
  toggleForm() {
    if (!animationController.isAnimating) {
      animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MeshGradient(
              controller: _meshController,
              options: MeshGradientOptions(blend: 3.5, noiseIntensity: 0.5),
            ),
          ),
          // animated forms
          Center(
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                Offset offset =
                    animationController.value < 0.5
                        ? slideOutAnimation.value * size.width
                        : slideInAnimation.value * size.width;
                return Transform.translate(
                  offset: offset,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Builder(
                      builder: (context) {
                        if (animationController.value < 0.5) {
                          return (isLogin
                              ? LoginPage(callback: toggleForm)
                              : SignUpPage(callback: toggleForm));
                        } else {
                          return (isLogin
                              ? SignUpPage(callback: toggleForm)
                              : LoginPage(callback: toggleForm));
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: ChangeViewButton(isLogin: isLogin, callback: toggleForm),
          ),
        ],
      ),
    );
  }
}
