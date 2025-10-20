import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  // MediaQuery
  double get height => mediaQuery.size.height;
  double get width => mediaQuery.size.width;

  /// Colors
  Color get surface => theme.colorScheme.surface;
  Color get surfaceContainer => theme.colorScheme.surfaceContainer;
  Color get surfaceContainerHighest =>
      theme.colorScheme.surfaceContainerHighest;
  Color get onSurface => theme.colorScheme.onSurface;
  Color get primary => theme.colorScheme.primary;
  Color get error => theme.colorScheme.error;
}
