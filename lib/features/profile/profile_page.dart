import 'package:financy_app/common/extensions/extensions.dart';
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
    _profileController.addListener(_handleProfileStateChange);
  }

  @override
  void dispose() {
    _profileController.dispose();
    super.dispose();
  }

  void _handleProfileStateChange() {
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
      body: Stack(
        children: [
          const AppHeader(
            title: 'Profile',
          ),
          Positioned(
            top: 210.h,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  minRadius: 60.h,
                  child: const Icon(Icons.person),
                ),
                SizedBox(height: 20.h),
                AnimatedBuilder(
                  animation: _profileController,
                  builder: (context, child) {
                    if (_profileController.state is ProfileStateSuccess) {
                      final user =
                          (_profileController.state as ProfileStateSuccess)
                              .user;
                      return Column(
                        children: [
                          Text(
                            user.name!,
                            style: AppTextStyles.mediumText20,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            user.email!,
                            style: AppTextStyles.smallText.apply(
                              color: AppColors.green,
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 450.h,
            left: 32,
            right: 32,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: AppColors.green,
                          ),
                          const SizedBox(width: 8.0),
                          Flexible(
                            child: Text(
                              'Change name',
                              style: AppTextStyles.mediumText16w500
                                  .apply(color: AppColors.green),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock_person_rounded,
                            color: AppColors.green,
                          ),
                          const SizedBox(width: 8.0),
                          Flexible(
                            child: Text(
                              'Change password',
                              style: AppTextStyles.mediumText16w500
                                  .apply(color: AppColors.green),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  InkWell(
                    onTap: () async {
                      await locator.get<AuthService>().signOut();
                      await locator.get<SecureStorageService>().deleteAll();
                      await locator.get<DatabaseService>().deleteDB;
                      if (!mounted) return;

                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(NamedRoute.initial),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.logout_outlined,
                            color: AppColors.green,
                          ),
                          const SizedBox(width: 8.0),
                          Flexible(
                            child: Text(
                              'Logout',
                              style: AppTextStyles.mediumText16w500
                                  .apply(color: AppColors.green),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
