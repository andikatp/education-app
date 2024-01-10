import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:teacher/core/common/widgets/i_field.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool obsecurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            controller: widget.emailController,
            hintText: 'Email Address',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 25),
          IField(
            controller: widget.passwordController,
            obscureText: true,
            hintText: 'Password',
            suffixIcon: IconButton(
              onPressed: () =>
                  setState(() => obsecurePassword = !obsecurePassword),
              icon: Icon(
                obsecurePassword ? IconlyLight.show : IconlyLight.hide,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
