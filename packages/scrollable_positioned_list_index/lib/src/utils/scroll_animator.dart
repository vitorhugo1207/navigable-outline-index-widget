import 'package:flutter/widgets.dart';

/// Utility for smooth scroll animations.
class ScrollAnimator {
  /// Creates a scroll animator.
  ///
  /// [scrollController] is used to perform the scroll operations.
  /// [defaultDuration] is the default animation duration.
  /// [defaultCurve] is the default animation curve.
  ScrollAnimator({
    required this.scrollController,
    this.defaultDuration = const Duration(milliseconds: 300),
    this.defaultCurve = Curves.easeInOut,
  });

  /// The scroll controller to animate.
  final ScrollController scrollController;

  /// Default animation duration.
  final Duration defaultDuration;

  /// Default animation curve.
  final Curve defaultCurve;

  /// Animates the scroll to a specific offset.
  ///
  /// [offset] is the target scroll offset.
  /// [duration] overrides the default duration if provided.
  /// [curve] overrides the default curve if provided.
  Future<void> animateToOffset(
    double offset, {
    Duration? duration,
    Curve? curve,
  }) async {
    if (!scrollController.hasClients) return;

    await scrollController.animateTo(
      offset,
      duration: duration ?? defaultDuration,
      curve: curve ?? defaultCurve,
    );
  }

  /// Animates the scroll to make a widget visible.
  ///
  /// [context] is the BuildContext of the widget to scroll to.
  /// [alignment] controls where the widget should be positioned (0.0 = top, 1.0 = bottom).
  /// [duration] overrides the default duration if provided.
  /// [curve] overrides the default curve if provided.
  Future<void> animateToWidget(
    BuildContext context, {
    double alignment = 0.0,
    Duration? duration,
    Curve? curve,
  }) async {
    await Scrollable.ensureVisible(
      context,
      alignment: alignment,
      duration: duration ?? defaultDuration,
      curve: curve ?? defaultCurve,
    );
  }

  /// Animates the scroll to a widget identified by its GlobalKey.
  ///
  /// [key] is the GlobalKey of the widget to scroll to.
  /// [alignment] controls where the widget should be positioned (0.0 = top, 1.0 = bottom).
  /// [duration] overrides the default duration if provided.
  /// [curve] overrides the default curve if provided.
  Future<void> animateToKey(
    GlobalKey key, {
    double alignment = 0.0,
    Duration? duration,
    Curve? curve,
  }) async {
    final context = key.currentContext;
    if (context != null) {
      await animateToWidget(
        context,
        alignment: alignment,
        duration: duration,
        curve: curve,
      );
    }
  }

  /// Scrolls by a relative amount.
  ///
  /// [delta] is the amount to scroll (positive = down/right, negative = up/left).
  /// [duration] overrides the default duration if provided.
  /// [curve] overrides the default curve if provided.
  Future<void> scrollBy(
    double delta, {
    Duration? duration,
    Curve? curve,
  }) async {
    if (!scrollController.hasClients) return;

    final newOffset = scrollController.offset + delta;
    await animateToOffset(
      newOffset,
      duration: duration,
      curve: curve,
    );
  }

  /// Scrolls to the top of the scrollable.
  Future<void> scrollToTop({Duration? duration, Curve? curve}) async {
    await animateToOffset(0, duration: duration, curve: curve);
  }

  /// Scrolls to the bottom of the scrollable.
  Future<void> scrollToBottom({Duration? duration, Curve? curve}) async {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    await animateToOffset(maxScroll, duration: duration, curve: curve);
  }
}
