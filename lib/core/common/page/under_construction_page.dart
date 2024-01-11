import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:teacher/core/common/widgets/gradient_background.dart';
import 'package:teacher/core/res/media_res.dart';

class UnderConstractionPage extends StatelessWidget {
  const UnderConstractionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      image: MediaRes.onBoardingBackground,
      child: Center(
        child: Lottie.asset(
          MediaRes.pageUnderConstruction,
        ),
      ),
    );
  }
}
