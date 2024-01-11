import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:teacher/core/common/widgets/pop_up_item.dart';
import 'package:teacher/core/extensions/context_extension.dart';
import 'package:teacher/core/res/colours.dart';
import 'package:teacher/core/services/injection_container.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Account',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      actions: [
        PopupMenuButton(
          offset: const Offset(0, 50),
          surfaceTintColor: Colors.white,
          icon: const Icon(Icons.more_horiz),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          itemBuilder: (_) => [
            PopupMenuItem<void>(
              child: const PopUpItem(
                title: 'Edit Profile',
                icon: Icon(
                  Icons.edit_outlined,
                  color: Colours.neutralTextColour,
                ),
              ),
              onTap: () => context.push(const Placeholder()),
            ),
            PopupMenuItem<void>(
              child: const PopUpItem(
                title: 'Notification',
                icon: Icon(
                  IconlyLight.notification,
                  color: Colours.neutralTextColour,
                ),
              ),
              onTap: () => context.push(const Placeholder()),
            ),
            PopupMenuItem<void>(
              child: const PopUpItem(
                title: 'Edit Profile',
                icon: Icon(
                  Icons.edit_outlined,
                  color: Colours.neutralTextColour,
                ),
              ),
              onTap: () => context.push(const Placeholder()),
            ),
            PopupMenuItem<void>(
              child: const PopUpItem(
                title: 'Help',
                icon: Icon(
                  Icons.help_outline,
                  color: Colours.neutralTextColour,
                ),
              ),
              onTap: () => context.push(const Placeholder()),
            ),
            const PopupMenuItem<void>(
              height: 1,
              padding: EdgeInsets.zero,
              child: Divider(
                height: 1,
                color: Colors.grey,
              ),
            ),
            PopupMenuItem<void>(
              child: const PopUpItem(
                title: 'Logout',
                icon: Icon(
                  Icons.logout_rounded,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                sl<FirebaseAuth>().signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
