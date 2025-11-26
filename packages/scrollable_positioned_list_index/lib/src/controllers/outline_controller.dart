import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../models/outline_item.dart';

/// Controller for managing the outline state and navigation.
///
/// This controller handles:
/// - Tracking the currently active item based on scroll position
/// - Navigating to items when they are tapped
/// - Managing the expanded/collapsed state of the outline panel
class OutlineController extends ChangeNotifier {
  /// Creates an outline controller.
  ///
  /// [items] is the list of outline items to display.
  /// [scrollController] is used to detect scroll position and navigate.
  /// [debounceDuration] controls how often the active item is updated.
  OutlineController({
    required List<OutlineItem> items,
    this.scrollController,
    this.debounceDuration = const Duration(milliseconds: 100),
  }) : _items = items {
    _flattenedItems = _flattenItems(items);
    _setupScrollListener();
  }

  final List<OutlineItem> _items;
  late final List<OutlineItem> _flattenedItems;
  final ScrollController? scrollController;
  final Duration debounceDuration;

  Timer? _debounceTimer;
  String? _activeItemId;
  bool _isExpanded = false;
  final Set<String> _collapsedSections = {};

  /// The list of outline items.
  List<OutlineItem> get items => _items;

  /// The flattened list of all items including children.
  List<OutlineItem> get flattenedItems => _flattenedItems;

  /// The ID of the currently active item (visible in viewport).
  String? get activeItemId => _activeItemId;

  /// Whether the outline panel is currently expanded.
  bool get isExpanded => _isExpanded;

  /// IDs of sections that are collapsed in the outline.
  Set<String> get collapsedSections => _collapsedSections;

  /// Sets the active item by ID and notifies listeners.
  set activeItemId(String? id) {
    if (_activeItemId != id) {
      _activeItemId = id;
      notifyListeners();
    }
  }

  /// Expands the outline panel.
  void expand() {
    if (!_isExpanded) {
      _isExpanded = true;
      notifyListeners();
    }
  }

  /// Collapses the outline panel.
  void collapse() {
    if (_isExpanded) {
      _isExpanded = false;
      notifyListeners();
    }
  }

  /// Toggles the expanded state of the outline panel.
  void toggle() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  /// Toggles whether a section is collapsed.
  void toggleSection(String sectionId) {
    if (_collapsedSections.contains(sectionId)) {
      _collapsedSections.remove(sectionId);
    } else {
      _collapsedSections.add(sectionId);
    }
    notifyListeners();
  }

  /// Returns true if the given section is collapsed.
  bool isSectionCollapsed(String sectionId) {
    return _collapsedSections.contains(sectionId);
  }

  /// Scrolls to the specified item.
  ///
  /// [item] is the outline item to scroll to.
  /// [duration] is the animation duration (defaults to 300ms).
  /// [curve] is the animation curve (defaults to easeInOut).
  Future<void> scrollToItem(
    OutlineItem item, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    final context = item.widgetKey.currentContext;
    if (context != null) {
      await Scrollable.ensureVisible(
        context,
        duration: duration,
        curve: curve,
        alignment: 0.0,
      );
      _activeItemId = item.id;
      notifyListeners();
    }
  }

  /// Updates the active item based on current scroll position.
  void updateActiveItem() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, _detectActiveItem);
  }

  void _setupScrollListener() {
    scrollController?.addListener(updateActiveItem);
  }

  void _detectActiveItem() {
    String? closestItemId;
    double closestDistance = double.infinity;

    for (final item in _flattenedItems) {
      final context = item.widgetKey.currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          final position = renderBox.localToGlobal(Offset.zero);
          // Consider items that are at or near the top of the viewport
          if (position.dy >= -50 && position.dy < closestDistance) {
            closestDistance = position.dy;
            closestItemId = item.id;
          }
        }
      }
    }

    if (closestItemId != null && closestItemId != _activeItemId) {
      _activeItemId = closestItemId;
      notifyListeners();
    }
  }

  List<OutlineItem> _flattenItems(List<OutlineItem> items) {
    final result = <OutlineItem>[];
    for (final item in items) {
      result.addAll(item.flatten());
    }
    return result;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    scrollController?.removeListener(updateActiveItem);
    super.dispose();
  }
}
