import 'package:flutter/material.dart';

class HoverAnimatedCard extends StatefulWidget {
  final Widget child;

  const HoverAnimatedCard({super.key, required this.child});

  @override
  State<HoverAnimatedCard> createState() => _HoverAnimatedCardState();
}

class _HoverAnimatedCardState extends State<HoverAnimatedCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: Duration(milliseconds: 200),
        child: widget.child,
      ),
    );
  }
}
