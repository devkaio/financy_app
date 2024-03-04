import 'dart:developer';

import 'package:financy_app/common/constants/constants.dart';
import 'package:financy_app/common/utils/validator.dart';
import 'package:financy_app/common/widgets/widgets.dart';
import 'package:financy_app/features/forgot_password/forgot_password_state.dart';
import 'package:financy_app/locator.dart';
import 'package:flutter/material.dart';

import 'forgot_password_controller.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with CustomModalSheetMixin {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _forgotPasswordController = locator.get<ForgotPasswordController>();

  @override
  void initState() {
    super.initState();

    _forgotPasswordController.addListener(_handleForgotPasswordStateChange);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _forgotPasswordController.dispose();
    super.dispose();
  }

  void _onSendLinkButtonPressed() {
    final valid =
        _formKey.currentState != null && _formKey.currentState!.validate();
    if (valid) {
      _forgotPasswordController.forgotPassword(_emailController.text);
    } else {
      log("erro ao resetar a senha");
    }
  }

  void _handleForgotPasswordStateChange() {
    final state = _forgotPasswordController.state;
    switch (state.runtimeType) {
      case ForgotPasswordStateLoading:
        showDialog(
          context: context,
          builder: (context) => const CustomCircularProgressIndicator(),
        );
        break;
      case ForgotPasswordStateSuccess:
        Navigator.popAndPushNamed(
          context,
          NamedRoute.checkYourEmail,
        );
        break;
      case ForgotPasswordStateError:
        Navigator.pop(context);
        showCustomModalBottomSheet(
          context: context,
          content: (_forgotPasswordController.state as ForgotPasswordStateError)
              .message,
          buttonText: "Try again",
          onPressed: () => Navigator.pop(context),
        );
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        child: ListView(
          children: [
            Text(
              'Reset Your\nPassword',
              textAlign: TextAlign.center,
              style: AppTextStyles.mediumText36.copyWith(
                color: AppColors.greenOne,
              ),
            ),
            Image.asset('assets/images/forgot_password_image.png'),
            Text(
              'Enter your email address and a link will be sent to reset your password.',
              style: AppTextStyles.mediumText16w500
                  .apply(color: AppColors.darkGrey),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Form(
                key: _formKey,
                child: CustomTextFormField(
                  key: Keys.forgotPasswordEmailField,
                  padding: EdgeInsets.zero,
                  controller: _emailController,
                  labelText: "your email",
                  hintText: "john@email.com",
                  validator: Validator.validateEmail,
                ),
              ),
            ),
            PrimaryButton(
              key: Keys.forgotPasswordSendLinkButton,
              text: 'Send Link',
              onPressed: _onSendLinkButtonPressed,
            ),
            MultiTextButton(
              key: const Key('forgotPasswordSignUpButton'),
              onPressed: () => Navigator.popAndPushNamed(
                context,
                NamedRoute.signUp,
              ),
              children: [
                Text(
                  'Don\'t have account? ',
                  style: AppTextStyles.smallText.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                Text(
                  'Sign Up',
                  style: AppTextStyles.smallText.copyWith(
                    color: AppColors.greenOne,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
