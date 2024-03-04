import 'package:financy_app/common/extensions/extensions.dart';
import 'package:financy_docs/financy_docs.dart';
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
  final _syncController = locator.get<SyncController>();

  @override
  void initState() {
    super.initState();
    _profileController.getUserData();
    _profileController.addListener(_handleProfileStateChange);
    _syncController.addListener(_handleSyncStateChange);
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
              NamedRoute.initial,
              (route) => false,
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

  void _handleSyncStateChange() async {
    switch (_syncController.state.runtimeType) {
      case DownloadingDataFromServer:
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const PopScope(
            canPop: false,
            child: CustomCircularProgressIndicator(),
          ),
        );
        break;
      case DownloadedDataFromServer:
        _syncController.syncToServer();
        break;
      case UploadedDataToServer:
        Navigator.pop(context);
        await locator.get<AuthService>().signOut();
        await locator.get<SecureStorageService>().deleteAll();
        await locator.get<DatabaseService>().deleteDB;
        if (!mounted) return;

        Navigator.popAndPushNamed(
          context,
          NamedRoute.initial,
        );
        break;
      case SyncStateError:
      case UploadDataToServerError:
      case DownloadDataFromServerError:
        Navigator.pop(context);
        showCustomModalBottomSheet(
          context: context,
          content: (_syncController.state as SyncStateError).message,
          buttonText: "Try again",
          onPressed: () => Navigator.of(context).pop(),
        );
        break;
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
                  backgroundColor: AppColors.greenTwo,
                  child: const Icon(
                    Icons.person,
                    color: AppColors.antiFlashWhite,
                  ),
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
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Agreements(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.policy,
                                      color: AppColors.green,
                                    ),
                                    label: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Agreements',
                                        style: AppTextStyles.mediumText16w500
                                            .apply(color: AppColors.green),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      showCustomModalBottomSheet(
                                        context: context,
                                        content:
                                            'Are you sure you want to delete your account? This action cannot be undone.',
                                        buttonText: 'Delete',
                                        onPressed: () async {
                                          Navigator.of(context).pop();

                                          await _profileController
                                              .deleteAccount();
                                          await locator
                                              .get<SecureStorageService>()
                                              .deleteAll();
                                          await locator
                                              .get<DatabaseService>()
                                              .deleteDB;

                                          if (!mounted) return;
                                          Navigator.popAndPushNamed(
                                            context,
                                            NamedRoute.initial,
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      color: AppColors.green,
                                    ),
                                    label: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Delete account',
                                        style: AppTextStyles.mediumText16w500
                                            .apply(color: AppColors.green),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    key: Keys.profilePagelogoutButton,
                                    onPressed: () {
                                      _syncController.syncFromServer();
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
