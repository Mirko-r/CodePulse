import 'package:flutter/material.dart';

class VisualizerArea extends StatelessWidget {
  const VisualizerArea({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),

      child: const Center(
        child: Text(
          'Visualizer Area',
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
      ),
    );
  }
}
