import 'package:flutter/material.dart';

import '../models/outline_trigger_mode.dart';

/// A floating button that triggers the outline panel to expand.
///
/// This widget displays a semi-transparent icon that can be tapped or hovered
/// to open the outline panel.
class OutlineTriggerButton extends StatelessWidget {
  /// Creates an outline trigger button.
  const OutlineTriggerButton({
    super.key,
    required this.onTrigger,
    this.triggerMode = OutlineTriggerMode.both,
    this.icon = Icons.menu,
    this.iconColor,
    this.iconSize = 24.0,
    this.backgroundColor,
    this.backgroundOpacity = 0.8,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(8.0),
    this.isExpanded = false,
  });

  /// Callback when the button is triggered (tap or hover).
  final VoidCallback onTrigger;

  /// How the button triggers the panel.
  final OutlineTriggerMode triggerMode;

  /// The icon to display.
  final IconData icon;

  /// The color of the icon.
  final Color? iconColor;

  /// The size of the icon.
  final double iconSize;

  /// The background color of the button.
  final Color? backgroundColor;

  /// The opacity of the background (0.0 to 1.0).
  final double backgroundOpacity;

  /// The border radius of the button.
  final double borderRadius;

  /// The padding around the icon.
  final EdgeInsets padding;

  /// Whether the panel is currently expanded.
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = (backgroundColor ?? theme.cardColor)
        .withValues(alpha: backgroundOpacity);
    final effectiveIconColor = iconColor ?? theme.iconTheme.color;

    Widget button = Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: padding,
      child: Icon(
        isExpanded ? Icons.close : icon,
        color: effectiveIconColor,
        size: iconSize,
      ),
    );

    // Handle different trigger modes
    if (triggerMode == OutlineTriggerMode.hover ||
        triggerMode == OutlineTriggerMode.both) {
      button = MouseRegion(
        onEnter: (_) => onTrigger(),
        child: button,
      );
    }

    if (triggerMode == OutlineTriggerMode.tap ||
        triggerMode == OutlineTriggerMode.both) {
      button = GestureDetector(
        onTap: onTrigger,
        child: button,
      );
    }

    return button;
  }
}
