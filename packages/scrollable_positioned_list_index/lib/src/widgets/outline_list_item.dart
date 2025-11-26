import 'package:flutter/material.dart';

import '../models/outline_item.dart';

/// A single item in the outline list.
///
/// Displays the item title with proper indentation and an optional active indicator.
class OutlineListItem extends StatelessWidget {
  /// Creates an outline list item.
  const OutlineListItem({
    super.key,
    required this.item,
    required this.onTap,
    this.isActive = false,
    this.isCollapsed = false,
    this.onToggleCollapse,
    this.textStyle,
    this.activeTextStyle,
    this.hoverColor,
    this.activeIndicatorColor,
    this.indentationWidth = 16.0,
  });

  /// The outline item to display.
  final OutlineItem item;

  /// Callback when the item is tapped.
  final VoidCallback onTap;

  /// Whether this item is currently active (visible in viewport).
  final bool isActive;

  /// Whether this item's children are collapsed.
  final bool isCollapsed;

  /// Callback to toggle collapse state (for items with children).
  final VoidCallback? onToggleCollapse;

  /// Text style for inactive items.
  final TextStyle? textStyle;

  /// Text style for the active item.
  final TextStyle? activeTextStyle;

  /// Background color when hovering.
  final Color? hoverColor;

  /// Color of the active indicator.
  final Color? activeIndicatorColor;

  /// Width of indentation per level.
  final double indentationWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTextStyle = textStyle ??
        theme.textTheme.bodyMedium ??
        const TextStyle(fontSize: 14);
    final effectiveActiveTextStyle = activeTextStyle ??
        effectiveTextStyle.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.primaryColor,
        );
    final effectiveHoverColor = hoverColor ??
        theme.hoverColor;
    final effectiveActiveIndicatorColor =
        activeIndicatorColor ?? theme.primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: effectiveHoverColor,
        child: Container(
          padding: EdgeInsets.only(
            left: 12.0 + (item.level * indentationWidth),
            right: 12.0,
            top: 8.0,
            bottom: 8.0,
          ),
          child: Row(
            children: [
              // Active indicator
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  color: isActive
                      ? effectiveActiveIndicatorColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              const SizedBox(width: 8),
              // Collapse toggle for items with children
              if (item.hasChildren)
                GestureDetector(
                  onTap: onToggleCollapse,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      isCollapsed
                          ? Icons.chevron_right
                          : Icons.keyboard_arrow_down,
                      size: 16,
                      color: theme.iconTheme.color?.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              // Optional icon
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: 16,
                  color: isActive
                      ? effectiveActiveIndicatorColor
                      : theme.iconTheme.color?.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 8),
              ],
              // Title
              Expanded(
                child: Text(
                  item.title,
                  style: isActive ? effectiveActiveTextStyle : effectiveTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Child count badge when collapsed
              if (item.hasChildren && isCollapsed)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${item.children!.length}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
