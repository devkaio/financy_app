import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../extensions/extensions.dart';
import 'widgets.dart';

class AppHeader extends StatefulWidget {
  const AppHeader({
    super.key,
    this.title,
    this.suffixOption = false,
    this.preffixOption = false,
    this.onPressed,
  }) : _withBackground = true;

  const AppHeader.noBackground({
    super.key,
    this.title,
    this.suffixOption = false,
    this.preffixOption = false,
    this.onPressed,
  }) : _withBackground = false;

  final String? title;
  final bool suffixOption;
  final bool preffixOption;
  final VoidCallback? onPressed;
  final bool _withBackground;

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  Widget get _child => widget.title != null
      ? Text(
          textAlign: TextAlign.center,
          widget.title!,
          style: AppTextStyles.mediumText18.apply(
            color:
                widget._withBackground ? AppColors.white : AppColors.blackGrey,
          ),
        )
      : const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GreetingsWidget(),
            // TODO: implement notifications widget and page
            // NotificationWidget(),
          ],
        );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget._withBackground)
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppColors.greenGradient,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(500, 30),
                  bottomRight: Radius.elliptical(500, 30),
                ),
              ),
              height: 287.h,
            ),
          ),
        Positioned(
          left: 24.0.w,
          right: 24.0.w,
          top: 74.h,
          child: _child,
        ),
        if (widget.preffixOption)
          Positioned(
            left: 8.0.w,
            top: 56.h,
            child: GestureDetector(
              onTap: widget.onPressed ?? () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        if (widget.suffixOption)
          Positioned(
            right: 8.0.w,
            top: 56.0.h,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(
                Icons.more_horiz,
                color: AppColors.white,
              ),
            ),
          ),
      ],
    );
  }
}
