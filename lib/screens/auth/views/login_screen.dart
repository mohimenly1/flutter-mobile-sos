import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/route_constants.dart';
import 'components/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Image.asset(
                "assets/images/playstore.png",
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "نُرحب بعودتك !",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    const Text(
                      "Log in with your data that you intered during your registration.",
                    ),
                    const SizedBox(height: defaultPadding),
                    LogInForm(formKey: _formKey),
                    SizedBox(
                      height: size.height > 700
                          ? size.height * 0.1
                          : defaultPadding,
                    ),
                    // The button is inside the form now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("ليس لديك حساب ؟"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, signUpScreenRoute);
                          },
                          child: const Text("مشترك جديد"),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
