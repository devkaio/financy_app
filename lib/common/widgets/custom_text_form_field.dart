// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class CustomTextFormField extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final String? hintText;
  final String? labelText;
  final TextCapitalization? textCapitalization;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final bool? obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;

  const CustomTextFormField({
    Key? key,
    this.padding,
    this.hintText,
    this.labelText,
    this.textCapitalization,
    this.controller,
    this.keyboardType,
    this.maxLength,
    this.textInputAction,
    this.suffixIcon,
    this.obscureText,
    this.inputFormatters,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final defaultBorder = const OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.greenOne,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 12.0,
          ),
      child: TextFormField(
        validator: widget.validator,
        style: AppTextStyles.inputText.copyWith(color: AppColors.greenOne),
        inputFormatters: widget.inputFormatters,
        obscureText: widget.obscureText ?? false,
        textInputAction: widget.textInputAction,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          hintText: widget.hintText,
          hintStyle:
              AppTextStyles.inputHintText.copyWith(color: AppColors.greenTwo),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: widget.labelText?.toUpperCase(),
          labelStyle:
              AppTextStyles.inputLabelText.copyWith(color: AppColors.grey),
          focusedBorder: defaultBorder,
          errorBorder: defaultBorder.copyWith(
            borderSide: const BorderSide(
              color: AppColors.error,
            ),
          ),
          focusedErrorBorder: defaultBorder.copyWith(
            borderSide: const BorderSide(
              color: AppColors.error,
            ),
          ),
          enabledBorder: defaultBorder,
          disabledBorder: defaultBorder,
        ),
      ),
    );
  }
}
