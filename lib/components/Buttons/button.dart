import 'package:flutter/material.dart';

import '../../app_ui.dart';

class Button extends StatelessWidget {
  const Button(
      {super.key, this.height, this.width, this.color, this.child, this.onTap});

  final double? height;
  final double? width;
  final Widget? child;
  final Color? color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 45,
        width: width ?? 360,
        decoration: BoxDecoration(
            color: color ?? AppUi.grey.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(15)),
        child: child,
      )
    );
  }
}
