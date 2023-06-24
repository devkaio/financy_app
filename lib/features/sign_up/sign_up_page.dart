import 'dart:developer';

import 'package:flutter/material.dart';

import '../../common/constants/constants.dart';
import '../../common/utils/utils.dart';
import '../../common/widgets/widgets.dart';
import '../../locator.dart';
import 'sign_up_controller.dart';
import 'sign_up_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with CustomModalSheetMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _signUpController = locator.get<SignUpController>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _signUpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _signUpController.addListener(
      () {
        if (_signUpController.state is SignUpStateLoading) {
          showDialog(
            context: context,
            builder: (context) => const CustomCircularProgressIndicator(),
          );
        }
        if (_signUpController.state is SignUpStateSuccess) {
          Navigator.pop(context);

          Navigator.pushReplacementNamed(
            context,
            NamedRoute.home,
          );
        }

        if (_signUpController.state is SignUpStateError) {
          final error = _signUpController.state as SignUpStateError;
          Navigator.pop(context);
          showCustomModalBottomSheet(
            context: context,
            content: error.message,
            buttonText: "Try again",
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        key: Keys.signUpListView,
        children: [
          Text(
            'Spend Smarter',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText36.copyWith(
              color: AppColors.greenOne,
            ),
          ),
          Text(
            'Save More',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText36.copyWith(
              color: AppColors.greenOne,
            ),
          ),
          Image.asset(
            'assets/images/sign_up_image.png',
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  key: Keys.signUpNameField,
                  controller: _nameController,
                  labelText: "your name",
                  hintText: "JOHN DOE",
                  inputFormatters: [
                    UpperCaseTextInputFormatter(),
                  ],
                  validator: Validator.validateName,
                ),
                CustomTextFormField(
                  key: Keys.signUpEmailField,
                  controller: _emailController,
                  labelText: "your email",
                  hintText: "john@email.com",
                  validator: Validator.validateEmail,
                ),
                PasswordFormField(
                  key: Keys.signUpPasswordField,
                  controller: _passwordController,
                  labelText: "choose your password",
                  hintText: "*********",
                  validator: Validator.validatePassword,
                  helperText:
                      "Must have at least 8 characters, 1 capital letter and 1 number.",
                ),
                PasswordFormField(
                  key: Keys.signUpConfirmPasswordField,
                  labelText: "confirm your password",
                  hintText: "*********",
                  validator: (value) => Validator.validateConfirmPassword(
                    _passwordController.text,
                    value,
                  ),
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
              key: Keys.signUpButton,
              text: 'Sign Up',
              onPressed: () {
                final valid = _formKey.currentState != null &&
                    _formKey.currentState!.validate();
                if (valid) {
                  _signUpController.signUp(
                    name: _nameController.text,
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
            key: Keys.signUpAlreadyHaveAccountButton,
            onPressed: () => Navigator.popAndPushNamed(
              context,
              NamedRoute.signIn,
            ),
            children: [
              Text(
                'Already have account? ',
                style: AppTextStyles.smallText.copyWith(
                  color: AppColors.grey,
                ),
              ),
              Text(
                'Sign In ',
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
