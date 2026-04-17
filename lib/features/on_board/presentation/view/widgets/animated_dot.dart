import 'package:flutter/material.dart';

class AnimatedDotContainer extends StatefulWidget {
  final int count;
  final int activeIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double activeDotWidth;
  final double spacing;

  const AnimatedDotContainer({
    super.key,
    required this.count,
    required this.activeIndex,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.white54,
    this.dotSize = 8,
    this.activeDotWidth = 24,
    this.spacing = 6,
  });

  @override
  State<AnimatedDotContainer> createState() => _AnimatedDotContainerState();
}

class _AnimatedDotContainerState extends State<AnimatedDotContainer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.count, (index) {
        final isActive = index == widget.activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
          width: isActive ? widget.activeDotWidth : widget.dotSize,
          height: widget.dotSize,
          decoration: BoxDecoration(
            color: isActive ? widget.activeColor : widget.inactiveColor,
            borderRadius: BorderRadius.circular(widget.dotSize / 2),
          ),
        );
      }),
    );
  }
}
