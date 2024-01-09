import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teacher/core/common/widgets/gradient_background.dart';
import 'package:teacher/core/res/colours.dart';
import 'package:teacher/core/res/media_res.dart';
import 'package:teacher/features/on_boarding/domain/page_content.dart';
import 'package:teacher/features/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:teacher/features/on_boarding/presentation/widgets/loading_widget.dart';
import 'package:teacher/features/on_boarding/presentation/widgets/on_boarding_body.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  static const routeName = '/';

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late PageController controller;

  @override
  void initState() {
    controller = PageController();
    context.read<OnBoardingCubit>().isUserFirstTimer();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnBoardingCubit, OnBoardingState>(
        listener: (context, state) {
          if (state is OnBoardingStatus && !state.isFirstTimer) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is UserCached) {
            Navigator.pushNamed(context, '/');
          }
        },
        builder: (context, state) {
          if (state is CheckingIfUserIsFirstTimer ||
              state is CachingFirstTimer) {
            return const LoadingWidget();
          }
          return GradientBackground(
            image: MediaRes.onBoardingBackground,
            child: Stack(
              children: [
                PageView(
                  controller: controller,
                  children: const [
                    OnBoardingBody(pageContent: PageContent.first()),
                    OnBoardingBody(pageContent: PageContent.second()),
                    OnBoardingBody(pageContent: PageContent.third()),
                  ],
                ),
                Align(
                  alignment: const Alignment(0, .04),
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    onDotClicked: (index) => controller.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                    effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 40,
                      activeDotColor: Colours.primaryColour,
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, .85),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO(Get-Started): Implement this functionality
                      context.read<OnBoardingCubit>().cacheFirstTimer();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 17,
                      ),
                      backgroundColor: Colours.primaryColour,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Get Started'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
