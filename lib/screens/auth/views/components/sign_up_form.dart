import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/screens/auth/views/auth_service.dart';

import '../../../../constants.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final AuthService _authService = AuthService();
  String email = '';
  String password = '';
  String name = '';

  // Function to handle registration
  Future<void> _register() async {
    if (widget.formKey.currentState!.validate()) {
      widget.formKey.currentState!.save();

      // Call registration service
      var response = await _authService.register(name, email, password);

      if (response['status']) {
        // Navigate to the next screen if registration is successful
        Navigator.pushNamedAndRemoveUntil(context, entryPointScreenRoute,
            ModalRoute.withName(signUpScreenRoute));
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (newValue) {
              name = newValue ?? '';
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Your Name",
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            onSaved: (newValue) {
              email = newValue ?? '';
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email",
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            onSaved: (newValue) {
              password = newValue ?? '';
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: _register, // Trigger registration
            child: const Text("Register"),
          ),
        ],
      ),
    );
  }
}
