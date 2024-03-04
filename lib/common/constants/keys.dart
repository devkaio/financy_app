import 'package:flutter/foundation.dart';

class Keys {
  Keys._();

  // Onboarding page
  static const onboardingGetStartedButton =
      Key('onboarding_get_started_button');
  static const onboardingAlreadyHaveAccountButton =
      Key('onboarding_already_have_account_button');

  // Sign up page
  static const signUpListView = Key('sign_up_listview');
  static const signUpNameField = Key('sign_up_name_field');
  static const signUpEmailField = Key('sign_up_email_field');
  static const signUpPasswordField = Key('sign_up_password_field');
  static const signUpConfirmPasswordField =
      Key('sign_up_confirm_password_field');
  static const signUpButton = Key('sign_up_button');
  static const signUpShowHidePasswordButton =
      Key('sign_up_show_hide_password_button');
  static const signUpAlreadyHaveAccountButton =
      Key('sign_up_already_have_account_button');

  // Sign in page
  static const signInListView = Key('sign_in_listview');
  static const signInEmailField = Key('sign_in_email_field');
  static const signInPasswordField = Key('sign_in_password_field');
  static const signInButton = Key('sign_in_button');
  static const signInShowHidePasswordButton =
      Key('sign_in_show_hide_password_button');
  static const signInDontHaveAccountButton =
      Key('sign_in_dont_have_account_button');

  // Forgot password page
  static const forgotPasswordButton = Key('forgot_password_button');
  static const forgotPasswordEmailField = Key('forgot_password_email_field');
  static const forgotPasswordSendLinkButton =
      Key('forgot_password_send_link_button');

  // App bottom bar items
  static const homePageBottomAppBarItem = Key('home_page_bottom_app_bar_item');
  static const statsPageBottomAppBarItem =
      Key('stats_page_bottom_app_bar_item');
  static const walletPageBottomAppBarItem =
      Key('wallet_page_bottom_app_bar_item');
  static const profilePageBottomAppBarItem =
      Key('profile_page_bottom_app_bar_item');

  // Profile page
  static const profilePagelogoutButton = Key('profile_page_logout_button');
}
