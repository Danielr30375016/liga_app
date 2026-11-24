import 'package:flutter/widgets.dart';

/// Breakpoints de Material 3
abstract final class Breakpoints {
  static const double medium = 600; // tablet vertical
  static const double expanded = 840; // tablet horizontal, web y escritorio
}

enum ScreenSize { compact, medium, expanded }

extension ScreenSizeX on BuildContext {
  /// Tamaño de la pantalla según el ancho (sólo se redibuja si cambia el tamaño)
  ScreenSize get screenSize {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= Breakpoints.expanded) return ScreenSize.expanded;
    if (width >= Breakpoints.medium) return ScreenSize.medium;
    return ScreenSize.compact;
  }
}
