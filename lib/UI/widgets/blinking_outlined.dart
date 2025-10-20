import 'package:flutter/material.dart';

class BlinkingOutline extends StatefulWidget {
  const BlinkingOutline({super.key});

  @override
  State<BlinkingOutline> createState() => _BlinkingOutlineState();
}

class _BlinkingOutlineState extends State<BlinkingOutline>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _colorAnim = ColorTween(
      begin: Colors.transparent,
      end: Colors.red.withOpacity(0.5),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnim,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: _colorAnim.value!, width: 5),
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}
