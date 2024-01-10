part of 'router.dart';

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
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignUpPage(),
        ),
        settings: routeSettings,
      );
    case '/forgot-password':
      return _pageBuilder(
          (_) => BlocProvider(
                create: (_) => sl<AuthBloc>(),
                child: const ForgotPasswordScreen(),
              ),
          settings: routeSettings,);
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
