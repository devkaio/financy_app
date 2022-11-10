// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:financy_app/common/utils/uppercase_text_formatter.dart';
import 'package:financy_app/common/widgets/password_form_field.dart';
import 'package:flutter/material.dart';

import '../../common/constants/app_colors.dart';
import '../../common/constants/app_text_styles.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/multi_text_button.dart';
import '../../common/widgets/primary_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Text(
            'Spend Smarter',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.greenOne,
            ),
          ),
          Text(
            'Save More',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText.copyWith(
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
                  labelText: "your name",
                  hintText: "JOHN DOE",
                  inputFormatters: [
                    UpperCaseTextInputFormatter(),
                  ],
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "esse campo não pode ser vazio";
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  labelText: "your email",
                  hintText: "john@email.com",
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "esse campo não pode ser vazio";
                    }
                    return null;
                  },
                ),
                PasswordFormField(
                  labelText: "choose your password",
                  hintText: "*********",
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "esse campo não pode ser vazio";
                    }
                    return null;
                  },
                  helperText:
                      "Must have at least 8 characters, 1 capital letter and 1 number.",
                ),
                PasswordFormField(
                  labelText: "confirm your password",
                  hintText: "*********",
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "esse campo não pode ser vazio";
                    }
                    return null;
                  },
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
              text: 'Sign Up',
              onPressed: () {
                final valid = _formKey.currentState != null &&
                    _formKey.currentState!.validate();
                if (valid) {
                  log("continuar lógica de login");
                } else {
                  log("erro ao logar");
                }
              },
            ),
          ),
          MultiTextButton(
            onPressed: () => log('tap'),
            children: [
              Text(
                'Already have account? ',
                style: AppTextStyles.smallText.copyWith(
                  color: AppColors.grey,
                ),
              ),
              Text(
                'Log In ',
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
