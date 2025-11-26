import 'package:flutter/widgets.dart';

import '../models/outline_item.dart';

/// Utility for detecting which outline item is currently visible in the viewport.
class OutlinePositionDetector {
  /// Creates a position detector.
  ///
  /// [items] is the list of outline items to track.
  /// [viewportTopOffset] is the offset from the top of the viewport to consider
  /// as the "active" zone (defaults to 0).
  OutlinePositionDetector({
    required List<OutlineItem> items,
    this.viewportTopOffset = 0.0,
  }) : _items = items;

  final List<OutlineItem> _items;
  final double viewportTopOffset;

  /// Finds the outline item that is currently most visible at the top of the viewport.
  ///
  /// Returns null if no items are currently visible.
  OutlineItem? detectActiveItem() {
    OutlineItem? closestItem;
    double closestDistance = double.infinity;

    for (final item in _getAllItems()) {
      final context = item.widgetKey.currentContext;
      if (context == null) continue;

      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.hasSize) continue;

      final position = renderBox.localToGlobal(Offset.zero);
      final distance = (position.dy - viewportTopOffset).abs();

      // Consider items that are at or above the viewport top
      if (position.dy <= viewportTopOffset + renderBox.size.height &&
          position.dy + renderBox.size.height > viewportTopOffset) {
        if (position.dy >= viewportTopOffset - 10 && distance < closestDistance) {
          closestDistance = distance;
          closestItem = item;
        }
      }
    }

    // If no item is at the top, find the first visible item
    if (closestItem == null) {
      for (final item in _getAllItems()) {
        final context = item.widgetKey.currentContext;
        if (context == null) continue;

        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox == null || !renderBox.hasSize) continue;

        final position = renderBox.localToGlobal(Offset.zero);
        if (position.dy >= viewportTopOffset && position.dy < closestDistance) {
          closestDistance = position.dy;
          closestItem = item;
        }
      }
    }

    return closestItem;
  }

  /// Returns the visibility ratio (0.0 to 1.0) of an item in the viewport.
  ///
  /// Returns 0.0 if the item is not visible.
  double getItemVisibility(OutlineItem item, double viewportHeight) {
    final context = item.widgetKey.currentContext;
    if (context == null) return 0.0;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return 0.0;

    final position = renderBox.localToGlobal(Offset.zero);
    final itemTop = position.dy;
    final itemBottom = itemTop + renderBox.size.height;
    final viewportTop = viewportTopOffset;
    final viewportBottom = viewportTop + viewportHeight;

    // Check if item is outside viewport
    if (itemBottom <= viewportTop || itemTop >= viewportBottom) {
      return 0.0;
    }

    // Calculate visible portion
    final visibleTop = itemTop < viewportTop ? viewportTop : itemTop;
    final visibleBottom =
        itemBottom > viewportBottom ? viewportBottom : itemBottom;
    final visibleHeight = visibleBottom - visibleTop;

    return visibleHeight / renderBox.size.height;
  }

  /// Flattens all items including nested children.
  List<OutlineItem> _getAllItems() {
    final result = <OutlineItem>[];
    for (final item in _items) {
      result.addAll(item.flatten());
    }
    return result;
  }
}
