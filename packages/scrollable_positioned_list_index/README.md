# Scrollable Positioned List Index

A navigable outline/index widget for Flutter that provides a table of contents with smooth scrolling and position tracking, similar to modern editor outlines found in VSCode, Notion, Google Docs, and Obsidian.

[![pub package](https://img.shields.io/pub/v/scrollable_positioned_list_index.svg)](https://pub.dev/packages/scrollable_positioned_list_index)

## Features

- 🎯 **Floating trigger button** - Discrete and always accessible
- 📖 **Expandable panel** - Shows full navigation structure
- 📍 **Position tracking** - Automatically highlights the current section
- 🔄 **Smooth scrolling** - Animated navigation to sections
- 🌳 **Hierarchical support** - Nested sections with indentation
- 🎨 **Fully customizable** - Colors, sizes, icons, animations
- 📱 **Responsive** - Works on mobile, tablet, and desktop
- ♿ **Accessible** - Screen reader support and keyboard navigation

## Preview

| Collapsed State | Expanded Panel | Active Navigation |
|-----------------|----------------|-------------------|
| ![Collapsed](image1) | ![Expanded](image2) | ![Active](image3) |

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  scrollable_positioned_list_index: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list_index/scrollable_positioned_list_index.dart';

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _scrollController = ScrollController();
  
  // Create GlobalKeys for each section
  final _section1Key = GlobalKey();
  final _section2Key = GlobalKey();
  final _section3Key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ScrollableOutlineIndex(
      items: [
        OutlineItem(
          id: 'section1',
          title: 'Introduction',
          widgetKey: _section1Key,
          icon: Icons.info_outline,
        ),
        OutlineItem(
          id: 'section2',
          title: 'Features',
          widgetKey: _section2Key,
          icon: Icons.star_outline,
        ),
        OutlineItem(
          id: 'section3',
          title: 'Conclusion',
          widgetKey: _section3Key,
          icon: Icons.check_circle_outline,
        ),
      ],
      scrollController: _scrollController,
      position: OutlinePosition.right,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(key: _section1Key, child: Text('Section 1 content')),
            Container(key: _section2Key, child: Text('Section 2 content')),
            Container(key: _section3Key, child: Text('Section 3 content')),
          ],
        ),
      ),
    );
  }
}
```

## Hierarchical Outline

Support nested sections with multiple levels:

```dart
OutlineItem(
  id: 'features',
  title: 'Features',
  widgetKey: _featuresKey,
  children: [
    OutlineItem(
      id: 'navigation',
      title: 'Navigation',
      level: 1,
      widgetKey: _navigationKey,
    ),
    OutlineItem(
      id: 'customization',
      title: 'Customization',
      level: 1,
      widgetKey: _customizationKey,
    ),
  ],
),
```

## Customization

### Trigger Button

```dart
ScrollableOutlineIndex(
  triggerIcon: Icons.toc,
  triggerIconColor: Colors.white,
  triggerIconSize: 28.0,
  triggerBackgroundColor: Colors.blue,
  triggerBackgroundOpacity: 0.9,
  // ...
)
```

### Panel

```dart
ScrollableOutlineIndex(
  panelWidth: 300.0,
  panelBackgroundColor: Colors.white,
  panelElevation: 8.0,
  panelBorderRadius: BorderRadius.circular(16),
  panelTitle: 'Contents',
  // ...
)
```

### Items

```dart
ScrollableOutlineIndex(
  itemTextStyle: TextStyle(fontSize: 14),
  activeItemTextStyle: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
  activeItemIndicatorColor: Colors.blue,
  indentationWidth: 20.0,
  // ...
)
```

### Position

```dart
ScrollableOutlineIndex(
  position: OutlinePosition.left, // or OutlinePosition.right
  offsetFromEdge: 20.0,
  offsetFromTop: 100.0,
  // ...
)
```

### Trigger Mode

```dart
ScrollableOutlineIndex(
  triggerMode: OutlineTriggerMode.tap,    // Mobile
  // or
  triggerMode: OutlineTriggerMode.hover,  // Desktop
  // or
  triggerMode: OutlineTriggerMode.both,   // Both (default)
  // ...
)
```

### Animation

```dart
ScrollableOutlineIndex(
  expandAnimationDuration: Duration(milliseconds: 300),
  expandAnimationCurve: Curves.easeInOutCubic,
  // ...
)
```

## API Reference

### ScrollableOutlineIndex

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `items` | `List<OutlineItem>` | required | List of outline items |
| `child` | `Widget` | required | The scrollable content |
| `scrollController` | `ScrollController?` | null | Controller for scroll tracking |
| `position` | `OutlinePosition` | `right` | Panel position |
| `offsetFromEdge` | `double` | `16.0` | Distance from screen edge |
| `offsetFromTop` | `double` | `100.0` | Distance from top |
| `triggerMode` | `OutlineTriggerMode` | `both` | How to open panel |
| `panelWidth` | `double` | `280.0` | Width of expanded panel |
| `enabled` | `bool` | `true` | Enable/disable the outline |

### OutlineItem

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `id` | `String` | required | Unique identifier |
| `title` | `String` | required | Display title |
| `widgetKey` | `GlobalKey` | required | Reference to widget |
| `level` | `int` | `0` | Hierarchy level |
| `children` | `List<OutlineItem>?` | null | Nested items |
| `icon` | `IconData?` | null | Optional icon |

### OutlineController

Use for external control:

```dart
final controller = OutlineController(items: items);

// Expand/collapse programmatically
controller.expand();
controller.collapse();
controller.toggle();

// Scroll to item
await controller.scrollToItem(item);

// Check state
print(controller.isExpanded);
print(controller.activeItemId);
```

## Responsive Design

Adjust settings based on screen size:

```dart
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isMobile = screenWidth < 600;
  final isTablet = screenWidth >= 600 && screenWidth < 1200;

  return ScrollableOutlineIndex(
    triggerMode: isMobile 
        ? OutlineTriggerMode.tap 
        : OutlineTriggerMode.both,
    panelWidth: isMobile ? 250 : (isTablet ? 280 : 320),
    offsetFromEdge: isMobile ? 12 : 20,
    // ...
  );
}
```

## Theming

The widget automatically adapts to your app's theme. For dark mode:

```dart
MaterialApp(
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
  // The outline will adapt automatically
)
```

## Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.
