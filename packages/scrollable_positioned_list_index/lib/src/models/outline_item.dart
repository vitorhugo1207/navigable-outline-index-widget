import 'package:flutter/widgets.dart';

/// Represents an item in the outline navigation.
///
/// Each item corresponds to a section in the content that can be navigated to.
class OutlineItem {
  /// Creates an outline item.
  ///
  /// The [id] uniquely identifies this item.
  /// The [title] is displayed in the outline panel.
  /// The [level] determines the hierarchical indentation (0 = top level).
  /// The [widgetKey] references the widget to scroll to when this item is tapped.
  const OutlineItem({
    required this.id,
    required this.title,
    this.level = 0,
    required this.widgetKey,
    this.children,
    this.icon,
  });

  /// Unique identifier for this item.
  final String id;

  /// Display title for this item.
  final String title;

  /// Hierarchical level (0, 1, 2, etc.).
  /// Higher levels are indented more in the outline panel.
  final int level;

  /// Reference to the widget this item corresponds to.
  /// Used to detect position and scroll to the widget.
  final GlobalKey widgetKey;

  /// Child items for hierarchical display.
  final List<OutlineItem>? children;

  /// Optional icon to display next to the title.
  final IconData? icon;

  /// Returns true if this item has children.
  bool get hasChildren => children != null && children!.isNotEmpty;

  /// Returns all items including children in a flat list (pre-order traversal).
  List<OutlineItem> flatten() {
    final result = <OutlineItem>[this];
    if (hasChildren) {
      for (final child in children!) {
        result.addAll(child.flatten());
      }
    }
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutlineItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'OutlineItem(id: $id, title: $title, level: $level)';
}
