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
import 'package:teacher/features/auth/presentation/pages/sign_up_page.dart';
import 'package:teacher/features/auth/presentation/widgets/sign_in_form.dart';
import 'package:teacher/features/dashboard/presentations/pages/dashboard.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static const routeName = '/sign-in';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            CoreUtils.showSnacBar(context, state.message);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sign in to your account',
                        style: TextStyle(fontSize: 14),
                      ),
                      Baseline(
                        baseline: 100,
                        baselineType: TextBaseline.alphabetic,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            SignUpPage.routeName,
                          ),
                          child: const Text('Register Account'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SignInForm(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    formKey: _formKey,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/forgot-password'),
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (state is AuthLoading)
                    const Center(child: CupertinoActivityIndicator())
                  else
                    RoundedButton(
                      label: 'Sign In',
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        sl<FirebaseAuth>().currentUser?.reload();
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                SignInEvent(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
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
    );
  }
}
