import 'package:fbla_2025/app_ui.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Termsbox extends StatefulWidget {
  Termsbox({super.key, required this.term, required this.def});

  final String term;
  final String def;

  @override
  State<Termsbox> createState() => _TermsboxState();
}

class _TermsboxState extends State<Termsbox> with SingleTickerProviderStateMixin {
  bool click = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: math.pi,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final rotationValue = _animation.value;
          final isBack = rotationValue >= (math.pi / 2);
          
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(rotationValue),
            child: containerTerm(
              isBack,
              isBack ? widget.def : widget.term,
            ),
          );
        },
      ),
      onTap: () {
        setState(() {
          if (_animation.status != AnimationStatus.forward) {
            click = !click;
            if (click) {
              _controller.reverse();
            } else {
              _controller.forward();
            }
          }
        });
      },
    );
  }

  Widget containerTerm(bool isBack, String text) {
    return Container(
      height: 220,
      width: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppUi.grey.withValues(alpha: .3)
      ),
      child: Center(
        // Apply counter-rotation to the text when on back side
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..rotateY(isBack ? math.pi : 0),
          child: Text(text),
        ),
      ),
    );
  }
}