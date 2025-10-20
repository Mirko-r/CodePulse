import 'package:code_pulse/helpers/context.dart';
import 'package:flutter/material.dart';

class EditorArea extends StatelessWidget {
  const EditorArea({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'Code',
          style: TextStyle(fontSize: 20, color: context.onSurface),
        ),
      ),
    );
  }
}
