import 'package:flutter/material.dart';

class MultiTextButton extends StatelessWidget {
  final List<Text> children;
  final VoidCallback onPressed;

  const MultiTextButton({
    Key? key,
    required this.children,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}
