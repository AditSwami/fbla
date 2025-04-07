import 'package:flutter/material.dart';
import '../../app_ui.dart';

class Button extends StatelessWidget {
  const Button({
    super.key, 
    this.height, 
    this.width, 
    this.color, 
    this.child, 
    this.onTap,
    this.constraints
  });

  final double? height;
  final double? width;
  final Widget? child;
  final Color? color;
  final Function()? onTap;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        constraints: constraints,
        decoration: BoxDecoration(
          color: (color ?? AppUi.primary).withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color ?? AppUi.primary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (color ?? AppUi.primary).withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
