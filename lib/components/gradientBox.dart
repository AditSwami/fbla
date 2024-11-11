import 'package:flutter/material.dart';
import 'package:fbla_2025/app_ui.dart';

class Gradientbox extends StatefulWidget {
  const Gradientbox(
      {super.key, required this.height, required this.width, this.child});

  final double height;
  final double width;
  final Widget? child;

  @override
  State<Gradientbox> createState() => _GradientboxState(width: width, height: height, child: child);
}

class _GradientboxState extends State<Gradientbox> {
  _GradientboxState(
      {required this.height, required this.width, this.child});

  final double height;

  final double width;

  final Widget? child;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(children: [
        widget.child != null
            ? ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: widget.child!,
              )
            : const SizedBox.shrink(),
        ClipPath(
          clipper: _CenterCutPath(radius: 20, thickness: 2),
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [AppUi.primary, AppUi.backgroundDark, AppUi.backgroundDark])),
          ),
        ),
      ]);
    });
  }
}

class _CenterCutPath extends CustomClipper<Path> {
  final double radius;
  final double thickness;
  _CenterCutPath({this.radius = 0, this.thickness = 1});

  @override
  Path getClip(Size size) {
    final rect =
        Rect.fromLTRB(-size.width, -size.width, size.width * 2, size.width * 2);
    final double width = size.width - thickness * 2;
    final double height = size.height - thickness * 2;

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(thickness, thickness, width, height),
            Radius.circular(radius - thickness)),
      )
      ..addRect(rect);

    return path;
  }

  @override
  bool shouldReclip(covariant _CenterCutPath oldClipper) {
    return oldClipper.radius != radius || oldClipper.thickness != thickness;
  }
}
