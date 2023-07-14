import 'package:flutter/material.dart';

import '../../common/constants/constants.dart';
import '../../common/widgets/widgets.dart';
import '../../locator.dart';
import '../../services/services.dart';
import 'profile_controller.dart';
import 'profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with CustomModalSheetMixin {
  final _profileController = locator.get<ProfileController>();

  @override
  void initState() {
    super.initState();
    _profileController.getUserData();
    _profileController.addListener(_handleProfileState);
  }

  @override
  void dispose() {
    _profileController.dispose();
    super.dispose();
  }

  void _handleProfileState() {
    final state = (_profileController.state);

    switch (state.runtimeType) {
      case ProfileStateError:
        if (!mounted) return;

        showCustomModalBottomSheet(
          context: context,
          content: (_profileController.state as ProfileStateError).message,
          buttonText: 'Go to login',
          isDismissible: false,
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            NamedRoute.signIn,
            ModalRoute.withName(NamedRoute.initial),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Profile"),
            AnimatedBuilder(
              animation: _profileController,
              builder: (context, child) {
                if (_profileController.state is ProfileStateSuccess) {
                  final user =
                      (_profileController.state as ProfileStateSuccess).user;
                  return Column(
                    children: [
                      Text(user.name!),
                      Text(user.email!),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            TextButton(
              key: Keys.profilePagelogoutButton,
              onPressed: () async {
                await locator.get<AuthService>().signOut();
                await const SecureStorageService().deleteAll();
                await locator.get<DatabaseService>().deleteDB;
                if (mounted) {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                }
              },
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
