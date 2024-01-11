import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:teacher/core/common/app/providers/user_provider.dart';
import 'package:teacher/core/res/colours.dart';
import 'package:teacher/features/auth/data/models/local_user_model.dart';
import 'package:teacher/features/dashboard/providers/dashboard_controller.dart';
import 'package:teacher/features/dashboard/utils/dashboard_utils.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocalUserModel>(
      stream: DashboardUtils.userDataStream,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          context.read<UserProvider>().user = snapshot.data;
        }
        return Consumer<DashboardController>(
          builder: (_, controller, child) => Scaffold(
            body: IndexedStack(
              index: controller.currentIndex,
              children: controller.screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: controller.currentIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: Colors.white,
              elevation: 8,
              onTap: controller.changeIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    controller.currentIndex == 0
                        ? IconlyBold.home
                        : IconlyLight.home,
                    color: controller.currentIndex == 0
                        ? Colours.primaryColour
                        : Colors.grey,
                  ),
                  label: '',
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    controller.currentIndex == 1
                        ? IconlyBold.document
                        : IconlyLight.document,
                    color: controller.currentIndex == 1
                        ? Colours.primaryColour
                        : Colors.grey,
                  ),
                  label: '',
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    controller.currentIndex == 2
                        ? IconlyBold.chat
                        : IconlyLight.chat,
                    color: controller.currentIndex == 2
                        ? Colours.primaryColour
                        : Colors.grey,
                  ),
                  label: '',
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    controller.currentIndex == 3
                        ? IconlyBold.profile
                        : IconlyLight.profile,
                    color: controller.currentIndex == 3
                        ? Colours.primaryColour
                        : Colors.grey,
                  ),
                  label: '',
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
