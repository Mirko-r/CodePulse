import 'dart:ui';
import 'package:code_pulse/providers/top_bar/top_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/top_bar_model.dart';

class TopBar extends ConsumerWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(topBarStateProvider);
    final notifier = ref.read(topBarStateProvider.notifier);

    // Glassmorphism Container
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          constraints: const BoxConstraints(minWidth: 200),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Drag Handle
              Icon(Icons.drag_indicator, color: Colors.white38, size: 20),
              const SizedBox(width: 12),

              // Title
              Row(
                children: [
                  const Icon(Icons.flash_on, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Dart',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              Container(
                height: 24,
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white12,
              ),

              // Controls
              ..._buildControls(state, notifier),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildControls(TopBarModel state, var notifier) {
    final buttons = {
      'play': _ControlButton(
        icon: Icons.play_arrow_rounded,
        color: Colors.greenAccent,
        onTap: () => notifier.play(),
        tooltip: 'Run',
      ),
      'pause': _ControlButton(
        icon: Icons.pause_rounded,
        color: Colors.orangeAccent,
        onTap: () => notifier.pause(),
        tooltip: 'Pause',
      ),
      'stop': _ControlButton(
        icon: Icons.stop_rounded,
        color: Colors.redAccent,
        onTap: () => notifier.stop(),
        tooltip: 'Stop',
      ),
      'back': _ControlButton(
        icon: Icons.skip_previous_rounded,
        color: Colors.blueAccent,
        onTap: () => notifier.back(),
        tooltip: 'Step Back',
      ),
      'next': _ControlButton(
        icon: Icons.skip_next_rounded,
        color: Colors.blueAccent,
        onTap: () => notifier.next(),
        tooltip: 'Step Over',
      ),
    };

    switch (state.playerState) {
      case PlayerState.stopped:
        return [buttons['play']!];
      case PlayerState.running:
        return [buttons['pause']!, const SizedBox(width: 8), buttons['stop']!];
      case PlayerState.paused:
        return [
          buttons['back']!,
          const SizedBox(width: 8),
          buttons['play']!, // Resume
          const SizedBox(width: 8),
          buttons['next']!,
          const SizedBox(width: 16),
          buttons['stop']!,
        ];
    }
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;

  const _ControlButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3), width: 1.5),
              color: color.withOpacity(0.1),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ),
      ),
    );
  }
}
