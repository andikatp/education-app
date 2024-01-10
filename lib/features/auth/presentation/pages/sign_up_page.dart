import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher/core/common/widgets/gradient_background.dart';
import 'package:teacher/core/common/widgets/rounded_button.dart';
import 'package:teacher/core/extensions/context_extension.dart';
import 'package:teacher/core/res/fonts.dart';
import 'package:teacher/core/res/media_res.dart';
import 'package:teacher/core/services/injection_container.dart';
import 'package:teacher/core/utils/core_utils.dart';
import 'package:teacher/features/auth/data/models/local_user_model.dart';
import 'package:teacher/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:teacher/features/auth/presentation/pages/sign_in_page.dart';
import 'package:teacher/features/auth/presentation/widgets/sign_up_form.dart';
import 'package:teacher/features/dashboard/presentations/pages/dashboard.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const routeName = '/sign-up';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (_, state) {
            if (state is AuthError) {
              CoreUtils.showSnacBar(context, state.message);
            } else if (state is SignedUp) {
              context.read<AuthBloc>().add(
                    SignInEvent(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    ),
                  );
            } else if (state is SignedIn) {
              context.userProvider.initUser(state.user as LocalUserModel);
              Navigator.pushReplacementNamed(context, Dashboard.routeName);
            }
          },
          builder: (context, state) {
            return GradientBackground(
              image: MediaRes.authGradientBackground,
              child: SafeArea(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const Text(
                      'Easy to lean, discover more skills.',
                      style: TextStyle(
                        fontFamily: Fonts.aeonik,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sign Up for an account',
                      style: TextStyle(fontSize: 14),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          SignInPage.routeName,
                        ),
                        child: const Text('Already have an account?'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SignUpForm(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      fullNameController: _fullNameController,
                      formKey: _formKey,
                    ),
                    const SizedBox(height: 30),
                    if (state is AuthLoading)
                      const Center(child: CupertinoActivityIndicator())
                    else
                      RoundedButton(
                        label: 'Sign Up',
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          sl<FirebaseAuth>().currentUser?.reload();
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  SignUpEvent(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                    name: _fullNameController.text.trim(),
                                  ),
                                );
                          }
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
