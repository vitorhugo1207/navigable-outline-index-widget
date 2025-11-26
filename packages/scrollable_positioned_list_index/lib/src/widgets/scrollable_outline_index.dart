import 'package:flutter/material.dart';

import '../controllers/outline_controller.dart';
import '../models/outline_item.dart';
import '../models/outline_position.dart';
import '../models/outline_trigger_mode.dart';
import 'outline_panel.dart';
import 'outline_trigger_button.dart';

/// A navigable outline/index widget for Flutter.
///
/// This widget displays a floating trigger button that expands into a
/// navigation panel showing an outline of content sections. Users can
/// tap items in the outline to scroll to those sections.
///
/// Example usage:
/// ```dart
/// ScrollableOutlineIndex(
///   position: OutlinePosition.right,
///   items: [
///     OutlineItem(
///       id: 'section1',
///       title: 'Section 1',
///       widgetKey: section1Key,
///     ),
///     OutlineItem(
///       id: 'section2',
///       title: 'Section 2',
///       widgetKey: section2Key,
///     ),
///   ],
///   scrollController: scrollController,
///   child: SingleChildScrollView(
///     controller: scrollController,
///     child: Column(
///       children: [
///         Container(key: section1Key, ...),
///         Container(key: section2Key, ...),
///       ],
///     ),
///   ),
/// )
/// ```
class ScrollableOutlineIndex extends StatefulWidget {
  /// Creates a scrollable outline index.
  const ScrollableOutlineIndex({
    super.key,
    required this.items,
    required this.child,
    this.scrollController,
    this.position = OutlinePosition.right,
    this.offsetFromEdge = 16.0,
    this.offsetFromTop = 100.0,
    this.triggerMode = OutlineTriggerMode.both,
    this.autoHide = false,
    this.autoHideDuration = const Duration(seconds: 3),
    this.triggerIcon = Icons.list,
    this.triggerIconColor,
    this.triggerIconSize = 24.0,
    this.triggerBackgroundColor,
    this.triggerBackgroundOpacity = 0.9,
    this.panelWidth = 280.0,
    this.panelBackgroundColor,
    this.panelElevation = 4.0,
    this.panelBorderRadius,
    this.panelTitle = 'Outline',
    this.itemTextStyle,
    this.activeItemTextStyle,
    this.itemHoverColor,
    this.activeItemIndicatorColor,
    this.indentationWidth = 16.0,
    this.expandAnimationDuration = const Duration(milliseconds: 200),
    this.expandAnimationCurve = Curves.easeInOut,
    this.showSearch = false,
    this.enabled = true,
    this.controller,
  });

  /// The content to display with the outline overlay.
  final Widget child;

  /// List of outline items representing sections in the content.
  final List<OutlineItem> items;

  /// Controller for the scrollable content.
  /// Used to detect scroll position and navigate to items.
  final ScrollController? scrollController;

  /// Position of the outline trigger and panel.
  final OutlinePosition position;

  /// Distance from the screen edge.
  final double offsetFromEdge;

  /// Distance from the top of the screen.
  final double offsetFromTop;

  /// How the outline is triggered to open.
  final OutlineTriggerMode triggerMode;

  /// Whether to auto-hide the panel after inactivity.
  final bool autoHide;

  /// Duration before auto-hiding the panel.
  final Duration autoHideDuration;

  /// Icon for the trigger button.
  final IconData triggerIcon;

  /// Color of the trigger icon.
  final Color? triggerIconColor;

  /// Size of the trigger icon.
  final double triggerIconSize;

  /// Background color of the trigger button.
  final Color? triggerBackgroundColor;

  /// Opacity of the trigger button background.
  final double triggerBackgroundOpacity;

  /// Width of the expanded panel.
  final double panelWidth;

  /// Background color of the panel.
  final Color? panelBackgroundColor;

  /// Elevation (shadow) of the panel.
  final double panelElevation;

  /// Border radius of the panel.
  final BorderRadius? panelBorderRadius;

  /// Title displayed in the panel header.
  final String panelTitle;

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

  /// Duration of the expand/collapse animation.
  final Duration expandAnimationDuration;

  /// Curve of the expand/collapse animation.
  final Curve expandAnimationCurve;

  /// Whether to show the search field in the panel.
  final bool showSearch;

  /// Whether the outline is enabled.
  final bool enabled;

  /// Optional external controller for the outline.
  final OutlineController? controller;

  @override
  State<ScrollableOutlineIndex> createState() => _ScrollableOutlineIndexState();
}

class _ScrollableOutlineIndexState extends State<ScrollableOutlineIndex>
    with SingleTickerProviderStateMixin {
  late OutlineController _controller;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        OutlineController(
          items: widget.items,
          scrollController: widget.scrollController,
        );

    _animationController = AnimationController(
      vsync: this,
      duration: widget.expandAnimationDuration,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.expandAnimationCurve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.expandAnimationCurve,
    ));

    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(ScrollableOutlineIndex oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items && widget.controller == null) {
      _controller.dispose();
      _controller = OutlineController(
        items: widget.items,
        scrollController: widget.scrollController,
      );
      _controller.addListener(_onControllerChanged);
    }
  }

  void _onControllerChanged() {
    if (_controller.isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onControllerChanged);
    }
    super.dispose();
  }

  void _handleTrigger() {
    _controller.toggle();
  }

  void _handleClose() {
    _controller.collapse();
  }

  void _handleMouseEnter() {
    if (widget.triggerMode == OutlineTriggerMode.hover ||
        widget.triggerMode == OutlineTriggerMode.both) {
      _isHovering = true;
      _controller.expand();
    }
  }

  void _handleMouseExit() {
    if (widget.triggerMode == OutlineTriggerMode.hover ||
        widget.triggerMode == OutlineTriggerMode.both) {
      _isHovering = false;
      // Small delay before collapsing to allow moving to panel
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!_isHovering && mounted) {
          _controller.collapse();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        _buildOutlineOverlay(),
      ],
    );
  }

  Widget _buildOutlineOverlay() {
    final isLeft = widget.position == OutlinePosition.left;

    return Positioned(
      left: isLeft ? widget.offsetFromEdge : null,
      right: isLeft ? null : widget.offsetFromEdge,
      top: widget.offsetFromTop,
      child: MouseRegion(
        onEnter: (_) => _handleMouseEnter(),
        onExit: (_) => _handleMouseExit(),
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Panel (animated)
                if (isLeft) _buildAnimatedPanel(),
                // Trigger button
                _buildTriggerButton(),
                // Panel (animated) for right position
                if (!isLeft) _buildAnimatedPanel(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTriggerButton() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Hide trigger when panel is fully expanded
        if (_animationController.value >= 1.0) {
          return const SizedBox.shrink();
        }
        return FadeTransition(
          opacity: ReverseAnimation(_fadeAnimation),
          child: child,
        );
      },
      child: OutlineTriggerButton(
        onTrigger: _handleTrigger,
        triggerMode: widget.triggerMode,
        icon: widget.triggerIcon,
        iconColor: widget.triggerIconColor,
        iconSize: widget.triggerIconSize,
        backgroundColor: widget.triggerBackgroundColor,
        backgroundOpacity: widget.triggerBackgroundOpacity,
        isExpanded: _controller.isExpanded,
      ),
    );
  }

  Widget _buildAnimatedPanel() {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        if (_slideAnimation.value == 0) {
          return const SizedBox.shrink();
        }

        final isLeft = widget.position == OutlinePosition.left;
        final slideOffset = isLeft
            ? Offset(-1 + _slideAnimation.value, 0)
            : Offset(1 - _slideAnimation.value, 0);

        return FractionalTranslation(
          translation: slideOffset,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: OutlinePanel(
        controller: _controller,
        onClose: _handleClose,
        title: widget.panelTitle,
        width: widget.panelWidth,
        backgroundColor: widget.panelBackgroundColor,
        elevation: widget.panelElevation,
        borderRadius: widget.panelBorderRadius,
        itemTextStyle: widget.itemTextStyle,
        activeItemTextStyle: widget.activeItemTextStyle,
        itemHoverColor: widget.itemHoverColor,
        activeItemIndicatorColor: widget.activeItemIndicatorColor,
        indentationWidth: widget.indentationWidth,
        showSearch: widget.showSearch,
      ),
    );
  }
}
