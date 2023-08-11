import 'package:financy_app/common/extensions/extensions.dart';
import 'package:flutter/material.dart';

import '../../common/constants/constants.dart';
import '../../common/widgets/widgets.dart';
import '../../locator.dart';
import '../../services/services.dart';
import 'profile_controller.dart';
import 'profile_state.dart';
import 'widgets/profile_change_name_widget.dart';
import 'widgets/profile_change_password_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with CustomModalSheetMixin, CustomSnackBar {
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

    if (!mounted) return;

    switch (state.runtimeType) {
      case ProfileStateError:
        if (!mounted) return;

        if (_profileController.reauthRequired) {
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
        }

        if (_profileController.showChangeName ||
            _profileController.showChangePassword) {
          showCustomSnackBar(
            context: context,
            text: (_profileController.state as ProfileStateError).message,
            type: SnackBarType.error,
          );
        }
        break;

      case ProfileStateSuccess:
        if (_profileController.showNameUpdateMessage) {
          showCustomSnackBar(
            context: context,
            text: 'Name updated successfully',
            type: SnackBarType.success,
          );
        }
        if (_profileController.showPasswordUpdateMessage) {
          showCustomSnackBar(
            context: context,
            text: 'Password updated successfully',
            type: SnackBarType.success,
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    if (_profileController.state is ProfileStateLoading) {
                      return const CustomCircularProgressIndicator(
                          color: AppColors.green);
                    }
                    return Column(
                      children: [
                        Text(
                          (_profileController.userData.name ?? '').capitalize(),
                          style: AppTextStyles.mediumText20,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _profileController.userData.email ?? '',
                          style: AppTextStyles.smallText.apply(
                            color: AppColors.green,
                          ),
                        ),
                      ],
                    );
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
              child: ListenableBuilder(
                listenable: _profileController,
                builder: (context, child) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: _profileController.showChangeName
                        ? ProfileChangeNameWidget(
                            key: const ValueKey('change-name'),
                            profileController: _profileController,
                          )
                        : _profileController.showChangePassword
                            ? ProfileChangePasswordWidget(
                                key: const ValueKey('change-password'),
                                profileController: _profileController,
                              )
                            : Column(
                                key: UniqueKey(),
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      _profileController.onChangeNameTapped();
                                    },
                                    icon: const Icon(
                                      Icons.person,
                                      color: AppColors.green,
                                    ),
                                    label: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Change name',
                                        style: AppTextStyles.mediumText16w500
                                            .apply(color: AppColors.green),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      _profileController
                                          .onChangePasswordTapped();
                                    },
                                    icon: const Icon(
                                      Icons.lock_person_rounded,
                                      color: AppColors.green,
                                    ),
                                    label: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Change password',
                                        style: AppTextStyles.mediumText16w500
                                            .apply(color: AppColors.green),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () async {
                                      await locator
                                          .get<AuthService>()
                                          .signOut();
                                      await locator
                                          .get<SecureStorageService>()
                                          .deleteAll();
                                      await locator
                                          .get<DatabaseService>()
                                          .deleteDB;
                                      if (!mounted) return;

                                      Navigator.popUntil(
                                        context,
                                        ModalRoute.withName(NamedRoute.initial),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.logout_outlined,
                                      color: AppColors.green,
                                    ),
                                    label: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Logout',
                                        style: AppTextStyles.mediumText16w500
                                            .apply(color: AppColors.green),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
