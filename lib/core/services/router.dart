import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher/core/common/app/providers/user_provider.dart';
import 'package:teacher/core/common/views/under_construction_page.dart';
import 'package:teacher/core/extensions/context_extension.dart';
import 'package:teacher/core/services/injection_container.dart';
import 'package:teacher/features/auth/data/models/local_user_model.dart';
import 'package:teacher/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:teacher/features/auth/presentation/pages/sign_in_page.dart';
import 'package:teacher/features/auth/presentation/pages/sign_up_page.dart';
import 'package:teacher/features/dashboard/presentations/pages/dashboard.dart';
import 'package:teacher/features/on_boarding/data/datasource/on_boarding_local_data_source.dart';
import 'package:teacher/features/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:teacher/features/on_boarding/presentation/pages/on_boarding_page.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case '/':
      final prefs = sl<SharedPreferences>();
      return _pageBuilder(
        (context) {
          if (prefs.getBool(kFirstTimerKey) ?? true) {
            return BlocProvider(
              create: (_) => sl<OnBoardingCubit>(),
              child: const OnBoardingPage(),
            );
          } else if (sl<FirebaseAuth>().currentUser != null) {
            final user = sl<FirebaseAuth>().currentUser!;
            final localUser = LocalUserModel(
              uid: user.uid,
              email: user.email ?? '',
              points: 0,
              fullName: user.displayName ?? '',
            );
            context.userProvider.initUser(localUser);
            return const Dashboard();
          }
          return BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: const SignInPage(),
          );
        },
        settings: routeSettings,
      );
    case SignInPage.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignInPage(),
        ),
        settings: routeSettings,
      );
    case SignUpPage.routeName:
      return _pageBuilder(
        (_) => const SignUpPage(),
        settings: routeSettings,
      );
    case Dashboard.routeName:
      return _pageBuilder((_) => const Dashboard(), settings: routeSettings);
    default:
      return _pageBuilder(
        (_) => const UnderConstractionPage(),
        settings: routeSettings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (_, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
    pageBuilder: (context, _, __) => page(context),
  );
}
