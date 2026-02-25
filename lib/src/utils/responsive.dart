import 'package:flutter/material.dart';

/// Breakpoints for responsive layout (width in logical pixels).
class Breakpoint {
  static const double compact = 600;

  /// Below this width use mobile shell (drawer + bottom nav). Above use side nav.
  static const double navRail = 760;
  static const double medium = 900;
  static const double large = 1200;
  /// 1440p-friendly content width.
  static const double wide = 1440;
  static const double xl = 1600;
}

extension ResponsiveContext on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
  bool get isCompact => width < Breakpoint.compact;

  /// True when drawer + bottom nav should be used instead of side nav.
  bool get useMobileShell => width < Breakpoint.navRail;
  bool get isMediumOrWider => width >= Breakpoint.medium;
  bool get isLargeOrWider => width >= Breakpoint.large;
  bool get isXlOrWider => width >= Breakpoint.xl;

  /// Content max width for readable desktop layout (up to 1440p).
  double get contentMaxWidth => width > Breakpoint.wide ? Breakpoint.wide : width;

  /// Horizontal padding that scales with screen size.
  double get responsivePadding =>
      isCompact ? 16 : (width > Breakpoint.large ? 32 : 24);
  int get courseGridCrossCount {
    if (width >= Breakpoint.wide) return 3;
    if (width >= Breakpoint.large) return 2;
    if (width >= Breakpoint.medium) return 2;
    return 1;
  }

  /// Stats card grid columns (e.g. Grades).
  int get statsGridCrossCount {
    if (width >= Breakpoint.wide) return 4;
    if (width >= Breakpoint.large) return 3;
    if (width >= Breakpoint.medium) return 2;
    return 1;
  }
}

/// Wraps child with responsive constraints and optional max width.
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final bool scroll;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.maxWidth,
    this.scroll = true,
  });

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(
      horizontal: context.responsivePadding,
      vertical: context.isCompact ? 16 : 24,
    );
    final content = maxWidth != null
        ? Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth!),
              child: Padding(padding: padding, child: child),
            ),
          )
        : Padding(padding: padding, child: child);
    return scroll ? SingleChildScrollView(child: content) : content;
  }
}
