import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:teacher/core/common/views/under_construction_page.dart';
import 'package:teacher/features/on_boarding/presentation/pages/on_boarding_page.dart';


Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case OnBoardingPage.routeName:
      return _pageBuilder(
        (_) => const OnBoardingPage(),
        settings: routeSettings,
      );
    default:
      return _pageBuilder(
        (_) => const UnderConstractionPage(),
        settings: routeSettings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext context) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
    pageBuilder: (context, _, __) => page(context),
  );
}
