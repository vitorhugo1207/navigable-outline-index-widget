import 'package:flutter/material.dart';

import '../controllers/outline_controller.dart';
import '../models/outline_item.dart';
import 'outline_list_item.dart';

/// The expandable panel that shows the outline navigation.
///
/// This panel slides in from the side when triggered and displays
/// a scrollable list of outline items.
class OutlinePanel extends StatelessWidget {
  /// Creates an outline panel.
  const OutlinePanel({
    super.key,
    required this.controller,
    required this.onClose,
    this.title = 'Outline',
    this.width = 280.0,
    this.backgroundColor,
    this.elevation = 4.0,
    this.borderRadius,
    this.itemTextStyle,
    this.activeItemTextStyle,
    this.itemHoverColor,
    this.activeItemIndicatorColor,
    this.indentationWidth = 16.0,
    this.showSearch = false,
  });

  /// The outline controller managing state.
  final OutlineController controller;

  /// Callback when the close button is pressed.
  final VoidCallback onClose;

  /// Title displayed at the top of the panel.
  final String title;

  /// Width of the panel.
  final double width;

  /// Background color of the panel.
  final Color? backgroundColor;

  /// Elevation (shadow) of the panel.
  final double elevation;

  /// Border radius of the panel.
  final BorderRadius? borderRadius;

  /// Text style for outline items.
  final TextStyle? itemTextStyle;

  /// Text style for the active outline item.
  final TextStyle? activeItemTextStyle;

  /// Hover color for outline items.
  final Color? itemHoverColor;

  /// Color of the active item indicator.
  final Color? activeItemIndicatorColor;

  /// Width of indentation per hierarchical level.
  final double indentationWidth;

  /// Whether to show the search field.
  final bool showSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? theme.cardColor;
    final effectiveBorderRadius =
        borderRadius ?? const BorderRadius.all(Radius.circular(12));

    return Material(
      elevation: elevation,
      borderRadius: effectiveBorderRadius,
      color: effectiveBackgroundColor,
      child: Container(
        width: width,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(context),
            // Search field (optional)
            if (showSearch) _buildSearchField(context),
            // Divider
            Divider(height: 1, color: theme.dividerColor),
            // Items list
            Flexible(
              child: _buildItemsList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      child: Row(
        children: [
          Icon(
            Icons.list_alt,
            size: 20,
            color: theme.iconTheme.color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search, size: 20),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
        ),
        style: theme.textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildItemsList(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final visibleItems = _getVisibleItems();
        return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: visibleItems.length,
          itemBuilder: (context, index) {
            final item = visibleItems[index];
            return OutlineListItem(
              item: item,
              onTap: () => controller.scrollToItem(item),
              isActive: controller.activeItemId == item.id,
              isCollapsed: controller.isSectionCollapsed(item.id),
              onToggleCollapse: item.hasChildren
                  ? () => controller.toggleSection(item.id)
                  : null,
              textStyle: itemTextStyle,
              activeTextStyle: activeItemTextStyle,
              hoverColor: itemHoverColor,
              activeIndicatorColor: activeItemIndicatorColor,
              indentationWidth: indentationWidth,
            );
          },
        );
      },
    );
  }

  /// Returns items that should be visible (respecting collapsed sections).
  List<OutlineItem> _getVisibleItems() {
    final result = <OutlineItem>[];
    _addVisibleItems(controller.items, result, null);
    return result;
  }

  void _addVisibleItems(
    List<OutlineItem> items,
    List<OutlineItem> result,
    String? parentId,
  ) {
    for (final item in items) {
      result.add(item);
      if (item.hasChildren && !controller.isSectionCollapsed(item.id)) {
        _addVisibleItems(item.children!, result, item.id);
      }
    }
  }
}
