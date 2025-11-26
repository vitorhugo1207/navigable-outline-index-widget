import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list_index/scrollable_positioned_list_index.dart';

void main() {
  runApp(const ExampleApp());
}

/// Example application demonstrating ScrollableOutlineIndex usage.
class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrollable Outline Index Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const ExamplePage(),
    );
  }
}

/// Example page with scrollable content and outline navigation.
class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final ScrollController _scrollController = ScrollController();

  // GlobalKeys for each section
  final _introductionKey = GlobalKey();
  final _gettingStartedKey = GlobalKey();
  final _installationKey = GlobalKey();
  final _configurationKey = GlobalKey();
  final _featuresKey = GlobalKey();
  final _navigationKey = GlobalKey();
  final _customizationKey = GlobalKey();
  final _advancedKey = GlobalKey();
  final _themingKey = GlobalKey();
  final _responsiveKey = GlobalKey();
  final _accessibilityKey = GlobalKey();
  final _conclusionKey = GlobalKey();

  late List<OutlineItem> _outlineItems;

  @override
  void initState() {
    super.initState();
    _outlineItems = [
      OutlineItem(
        id: 'introduction',
        title: 'Introduction',
        level: 0,
        widgetKey: _introductionKey,
        icon: Icons.info_outline,
      ),
      OutlineItem(
        id: 'getting-started',
        title: 'Getting Started',
        level: 0,
        widgetKey: _gettingStartedKey,
        icon: Icons.play_arrow,
        children: [
          OutlineItem(
            id: 'installation',
            title: 'Installation',
            level: 1,
            widgetKey: _installationKey,
          ),
          OutlineItem(
            id: 'configuration',
            title: 'Configuration',
            level: 1,
            widgetKey: _configurationKey,
          ),
        ],
      ),
      OutlineItem(
        id: 'features',
        title: 'Features',
        level: 0,
        widgetKey: _featuresKey,
        icon: Icons.star_outline,
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
      OutlineItem(
        id: 'advanced',
        title: 'Advanced Topics',
        level: 0,
        widgetKey: _advancedKey,
        icon: Icons.science_outlined,
        children: [
          OutlineItem(
            id: 'theming',
            title: 'Theming',
            level: 1,
            widgetKey: _themingKey,
          ),
          OutlineItem(
            id: 'responsive',
            title: 'Responsive Design',
            level: 1,
            widgetKey: _responsiveKey,
          ),
          OutlineItem(
            id: 'accessibility',
            title: 'Accessibility',
            level: 1,
            widgetKey: _accessibilityKey,
          ),
        ],
      ),
      OutlineItem(
        id: 'conclusion',
        title: 'Conclusion',
        level: 0,
        widgetKey: _conclusionKey,
        icon: Icons.check_circle_outline,
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrollable Outline Index Demo'),
        elevation: 2,
      ),
      body: ScrollableOutlineIndex(
        items: _outlineItems,
        scrollController: _scrollController,
        position: OutlinePosition.right,
        offsetFromEdge: 16,
        offsetFromTop: 80,
        triggerMode: OutlineTriggerMode.both,
        panelTitle: 'Contents',
        triggerIcon: Icons.toc,
        panelWidth: 280,
        showSearch: false,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    key: _introductionKey,
                    title: 'Introduction',
                    icon: Icons.info_outline,
                    content: '''
Welcome to the Scrollable Outline Index documentation! This package provides a navigable outline/index widget for Flutter that displays a floating trigger button expanding into a navigation panel showing an outline of content sections.

The widget is inspired by modern editor outlines found in VSCode, Notion, Google Docs, and Obsidian. It provides a smooth, intuitive way to navigate through long documents or pages with multiple sections.

Key benefits:
• Easy navigation through long content
• Automatic position tracking
• Smooth scroll animations
• Fully customizable appearance
• Support for hierarchical sections
                    ''',
                  ),
                  _buildSection(
                    key: _gettingStartedKey,
                    title: 'Getting Started',
                    icon: Icons.play_arrow,
                    content: '''
To get started with Scrollable Outline Index, you'll need to add the package to your Flutter project and configure it with your content sections.

The package is designed to be easy to integrate with any existing scrollable content, whether you're using SingleChildScrollView, ListView, or any other scrollable widget.
                    ''',
                  ),
                  _buildSubSection(
                    key: _installationKey,
                    title: 'Installation',
                    content: '''
Add the package to your pubspec.yaml:

dependencies:
  scrollable_positioned_list_index: ^0.1.0

Then run:
flutter pub get

Import the package in your Dart file:
import 'package:scrollable_positioned_list_index/scrollable_positioned_list_index.dart';
                    ''',
                  ),
                  _buildSubSection(
                    key: _configurationKey,
                    title: 'Configuration',
                    content: '''
Basic configuration requires:
1. A list of OutlineItem objects representing your sections
2. GlobalKeys for each section widget
3. A ScrollController for scroll tracking and navigation

Example:
final _sectionKey = GlobalKey();

OutlineItem(
  id: 'section1',
  title: 'Section 1',
  widgetKey: _sectionKey,
)

Then wrap your content with ScrollableOutlineIndex:
ScrollableOutlineIndex(
  items: outlineItems,
  scrollController: scrollController,
  child: YourScrollableContent(),
)
                    ''',
                  ),
                  _buildSection(
                    key: _featuresKey,
                    title: 'Features',
                    icon: Icons.star_outline,
                    content: '''
Scrollable Outline Index comes packed with features to enhance user navigation experience:

• Floating trigger button - Discrete and always accessible
• Expandable panel - Shows full navigation structure
• Position tracking - Highlights current section automatically
• Smooth scrolling - Animated navigation to sections
• Hierarchical support - Nested sections with indentation
• Collapsible sections - Clean interface for complex documents
                    ''',
                  ),
                  _buildSubSection(
                    key: _navigationKey,
                    title: 'Navigation',
                    content: '''
Navigation features include:
• Click-to-scroll: Tap any item to smoothly scroll to that section
• Position indicator: Active section is highlighted with a visual indicator
• Scroll sync: The outline automatically updates as you scroll through content
• Keyboard navigation: Support for keyboard-based navigation
                    ''',
                  ),
                  _buildSubSection(
                    key: _customizationKey,
                    title: 'Customization',
                    content: '''
Customize every aspect of the outline:
• Trigger button icon, color, and size
• Panel width, colors, and elevation
• Item text styles for normal and active states
• Indentation width for hierarchical items
• Animation duration and curves
• Position (left or right side of screen)
                    ''',
                  ),
                  _buildSection(
                    key: _advancedKey,
                    title: 'Advanced Topics',
                    icon: Icons.science_outlined,
                    content: '''
For more complex use cases, the package provides advanced features and configuration options.

These features are designed for developers who need fine-grained control over the outline behavior or want to integrate it with existing state management solutions.
                    ''',
                  ),
                  _buildSubSection(
                    key: _themingKey,
                    title: 'Theming',
                    content: '''
The outline widget automatically adapts to your app's theme, but you can also customize colors explicitly:

ScrollableOutlineIndex(
  triggerBackgroundColor: Colors.blue,
  panelBackgroundColor: Colors.white,
  activeItemIndicatorColor: Colors.blue,
  // ...
)

For dark mode support, the widget uses theme colors by default, ensuring it looks good in both light and dark themes.
                    ''',
                  ),
                  _buildSubSection(
                    key: _responsiveKey,
                    title: 'Responsive Design',
                    content: '''
The outline adapts to different screen sizes:
• Mobile: Consider using tap-only trigger mode
• Tablet: Medium panel width works well
• Desktop: Full width panel with hover support

You can use MediaQuery to adjust settings based on screen size:

final isMobile = MediaQuery.of(context).size.width < 600;

ScrollableOutlineIndex(
  triggerMode: isMobile ? OutlineTriggerMode.tap : OutlineTriggerMode.both,
  panelWidth: isMobile ? 250 : 300,
  // ...
)
                    ''',
                  ),
                  _buildSubSection(
                    key: _accessibilityKey,
                    title: 'Accessibility',
                    content: '''
Accessibility features:
• Semantic labels for screen readers
• Keyboard navigation support
• Focus management
• High contrast support
• Configurable font sizes

The package follows Flutter's accessibility best practices to ensure your app is usable by everyone.
                    ''',
                  ),
                  _buildSection(
                    key: _conclusionKey,
                    title: 'Conclusion',
                    icon: Icons.check_circle_outline,
                    content: '''
Scrollable Outline Index provides a powerful yet easy-to-use navigation solution for Flutter apps with long-form content.

Whether you're building documentation pages, article readers, or any app with structured content, this package will help your users navigate efficiently.

Thank you for using Scrollable Outline Index! For questions, feature requests, or bug reports, please visit our GitHub repository.
                    ''',
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required GlobalKey key,
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 28, color: Theme.of(context).primaryColor),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content.trim(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubSection({
    required GlobalKey key,
    required String title,
    required String content,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 24, left: 16),
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            content.trim(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
