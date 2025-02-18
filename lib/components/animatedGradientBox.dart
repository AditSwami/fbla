import 'package:flutter/material.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:flutter/scheduler.dart';

class Animatedgradientbox extends StatefulWidget {
  const Animatedgradientbox(
      {super.key, required this.height, required this.width, this.child});

  final double height;
  final double width;
  final Widget? child;

  @override
  State<Animatedgradientbox> createState() =>
      _AnimatedgradientboxState(height: height, width: width, child: child);
}

class _AnimatedgradientboxState extends State<Animatedgradientbox>
    with SingleTickerProviderStateMixin {
  _AnimatedgradientboxState(
      {required this.height, required this.width, this.child});

  final double height;
  final double width;

  late AnimationController _controller;
  late Animation<Alignment> _tlAlignAnim;
  late Animation<Alignment> _brAlignAnim;

  final Widget? child;

  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);

    _tlAlignAnim = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1),
    ]).animate(_controller);

    _brAlignAnim = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(children: [
        widget.child != null
          ? ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: widget.child!,
          )
          : const SizedBox.shrink(),
        ClipPath(
          clipper: _CenterCutPath(radius: 20, thickness: 1),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                        begin: _tlAlignAnim.value,
                        end: _brAlignAnim.value,
                        colors: [AppUi.primary, AppUi.backgroundDark])),
              );
            },
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
