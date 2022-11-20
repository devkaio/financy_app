// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:financy_app/common/constants/routes.dart';
import 'package:financy_app/common/utils/validator.dart';
import 'package:financy_app/common/widgets/custom_circular_progress_indicator.dart';
import 'package:financy_app/common/widgets/password_form_field.dart';
import 'package:financy_app/services/mock_auth_service.dart';
import 'package:flutter/material.dart';

import '../../common/constants/app_colors.dart';
import '../../common/constants/app_text_styles.dart';
import '../../common/widgets/custom_bottom_sheet.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/multi_text_button.dart';
import '../../common/widgets/primary_button.dart';
import 'sign_in_controller.dart';
import 'sign_in_state.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _controller = SignInController(MockAuthService());

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () {
        if (_controller.state is SignInStateLoading) {
          showDialog(
            context: context,
            builder: (context) => const CustomCircularProgressIndicator(),
          );
        }
        if (_controller.state is SignInStateSuccess) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(
                  child: Text("Nova Tela"),
                ),
              ),
            ),
          );
        }

        if (_controller.state is SignInStateError) {
          final error = _controller.state as SignInStateError;
          Navigator.pop(context);
          customModalBottomSheet(
            context,
            content: error.message,
            buttonText: "Tentar novamente",
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Text(
            'Welcome Back!',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.greenOne,
            ),
          ),
          Image.asset(
            'assets/images/sign_in_image.png',
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _emailController,
                  labelText: "your email",
                  hintText: "john@email.com",
                  validator: Validator.validateEmail,
                ),
                PasswordFormField(
                  controller: _passwordController,
                  labelText: "your password",
                  hintText: "*********",
                  validator: Validator.validatePassword,
                  helperText:
                      "Must have at least 8 characters, 1 capital letter and 1 number.",
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 32.0,
              right: 32.0,
              top: 16.0,
              bottom: 4.0,
            ),
            child: PrimaryButton(
              text: 'Sign In',
              onPressed: () {
                final valid = _formKey.currentState != null &&
                    _formKey.currentState!.validate();
                if (valid) {
                  _controller.signIn(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                } else {
                  log("erro ao logar");
                }
              },
            ),
          ),
          MultiTextButton(
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
    );
  }
}
