import 'package:flutter/material.dart';
import 'package:teacher/core/common/widgets/gradient_background.dart';
import 'package:teacher/core/res/media_res.dart';
import 'package:teacher/features/profile/presentations/widgets/profile_app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: const ProfileAppBar(),
      body: GradientBackground(
        image: MediaRes.profileGradientBackground,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }
}
