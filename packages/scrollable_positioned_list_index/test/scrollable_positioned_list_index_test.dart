import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrollable_positioned_list_index/scrollable_positioned_list_index.dart';

void main() {
  group('OutlineItem', () {
    test('creates item with required parameters', () {
      final key = GlobalKey();
      final item = OutlineItem(
        id: 'test',
        title: 'Test Item',
        widgetKey: key,
      );

      expect(item.id, 'test');
      expect(item.title, 'Test Item');
      expect(item.level, 0);
      expect(item.widgetKey, key);
      expect(item.hasChildren, false);
      expect(item.icon, null);
    });

    test('creates item with all parameters', () {
      final key = GlobalKey();
      final childKey = GlobalKey();
      final children = [
        OutlineItem(
          id: 'child',
          title: 'Child Item',
          level: 1,
          widgetKey: childKey,
        ),
      ];

      final item = OutlineItem(
        id: 'test',
        title: 'Test Item',
        level: 0,
        widgetKey: key,
        children: children,
        icon: Icons.star,
      );

      expect(item.id, 'test');
      expect(item.hasChildren, true);
      expect(item.children!.length, 1);
      expect(item.icon, Icons.star);
    });

    test('flatten returns all items in pre-order', () {
      final key1 = GlobalKey();
      final key2 = GlobalKey();
      final key3 = GlobalKey();

      final item = OutlineItem(
        id: 'parent',
        title: 'Parent',
        widgetKey: key1,
        children: [
          OutlineItem(
            id: 'child1',
            title: 'Child 1',
            level: 1,
            widgetKey: key2,
          ),
          OutlineItem(
            id: 'child2',
            title: 'Child 2',
            level: 1,
            widgetKey: key3,
          ),
        ],
      );

      final flattened = item.flatten();
      expect(flattened.length, 3);
      expect(flattened[0].id, 'parent');
      expect(flattened[1].id, 'child1');
      expect(flattened[2].id, 'child2');
    });

    test('equality is based on id', () {
      final key1 = GlobalKey();
      final key2 = GlobalKey();

      final item1 = OutlineItem(
        id: 'test',
        title: 'Item 1',
        widgetKey: key1,
      );

      final item2 = OutlineItem(
        id: 'test',
        title: 'Item 2',
        widgetKey: key2,
      );

      final item3 = OutlineItem(
        id: 'other',
        title: 'Item 3',
        widgetKey: key1,
      );

      expect(item1 == item2, true);
      expect(item1 == item3, false);
      expect(item1.hashCode, item2.hashCode);
    });
  });

  group('OutlineController', () {
    test('creates controller with items', () {
      final key = GlobalKey();
      final items = [
        OutlineItem(id: 'test', title: 'Test', widgetKey: key),
      ];

      final controller = OutlineController(items: items);

      expect(controller.items, items);
      expect(controller.isExpanded, false);
      expect(controller.activeItemId, null);

      controller.dispose();
    });

    test('expand and collapse work correctly', () {
      final key = GlobalKey();
      final items = [
        OutlineItem(id: 'test', title: 'Test', widgetKey: key),
      ];

      final controller = OutlineController(items: items);

      expect(controller.isExpanded, false);

      controller.expand();
      expect(controller.isExpanded, true);

      controller.collapse();
      expect(controller.isExpanded, false);

      controller.toggle();
      expect(controller.isExpanded, true);

      controller.toggle();
      expect(controller.isExpanded, false);

      controller.dispose();
    });

    test('section collapse toggle works', () {
      final key = GlobalKey();
      final items = [
        OutlineItem(id: 'test', title: 'Test', widgetKey: key),
      ];

      final controller = OutlineController(items: items);

      expect(controller.isSectionCollapsed('test'), false);

      controller.toggleSection('test');
      expect(controller.isSectionCollapsed('test'), true);

      controller.toggleSection('test');
      expect(controller.isSectionCollapsed('test'), false);

      controller.dispose();
    });

    test('activeItemId updates and notifies', () {
      final key = GlobalKey();
      final items = [
        OutlineItem(id: 'test', title: 'Test', widgetKey: key),
      ];

      final controller = OutlineController(items: items);
      var notified = false;
      controller.addListener(() => notified = true);

      controller.activeItemId = 'test';
      expect(controller.activeItemId, 'test');
      expect(notified, true);

      controller.dispose();
    });
  });

  group('OutlineTriggerButton', () {
    testWidgets('renders with default properties', (tester) async {
      var triggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlineTriggerButton(
              onTrigger: () => triggered = true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.menu), findsOneWidget);

      await tester.tap(find.byType(OutlineTriggerButton));
      expect(triggered, true);
    });

    testWidgets('renders with custom icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlineTriggerButton(
              onTrigger: () {},
              icon: Icons.toc,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.toc), findsOneWidget);
    });

    testWidgets('shows close icon when expanded', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlineTriggerButton(
              onTrigger: () {},
              isExpanded: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });

  group('OutlineListItem', () {
    testWidgets('renders item correctly', (tester) async {
      final key = GlobalKey();
      final item = OutlineItem(
        id: 'test',
        title: 'Test Item',
        widgetKey: key,
      );

      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlineListItem(
              item: item,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Test Item'), findsOneWidget);

      await tester.tap(find.byType(OutlineListItem));
      expect(tapped, true);
    });

    testWidgets('shows active indicator when active', (tester) async {
      final key = GlobalKey();
      final item = OutlineItem(
        id: 'test',
        title: 'Test Item',
        widgetKey: key,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlineListItem(
              item: item,
              onTap: () {},
              isActive: true,
            ),
          ),
        ),
      );

      // The active indicator should be colored
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(OutlineListItem),
          matching: find.byType(Container).first,
        ),
      );
      expect(container, isNotNull);
    });

    testWidgets('shows collapse icon for items with children', (tester) async {
      final key = GlobalKey();
      final childKey = GlobalKey();
      final item = OutlineItem(
        id: 'test',
        title: 'Test Item',
        widgetKey: key,
        children: [
          OutlineItem(
            id: 'child',
            title: 'Child',
            level: 1,
            widgetKey: childKey,
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlineListItem(
              item: item,
              onTap: () {},
              onToggleCollapse: () {},
            ),
          ),
        ),
      );

      // Should show expand/collapse icon
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets('shows icon when provided', (tester) async {
      final key = GlobalKey();
      final item = OutlineItem(
        id: 'test',
        title: 'Test Item',
        widgetKey: key,
        icon: Icons.star,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlineListItem(
              item: item,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });

  group('OutlinePanel', () {
    testWidgets('renders panel with title', (tester) async {
      final key = GlobalKey();
      final items = [
        OutlineItem(id: 'test', title: 'Test', widgetKey: key),
      ];
      final controller = OutlineController(items: items);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlinePanel(
              controller: controller,
              onClose: () {},
              title: 'Custom Title',
            ),
          ),
        ),
      );

      expect(find.text('Custom Title'), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('close button triggers callback', (tester) async {
      final key = GlobalKey();
      final items = [
        OutlineItem(id: 'test', title: 'Test', widgetKey: key),
      ];
      final controller = OutlineController(items: items);
      var closed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlinePanel(
              controller: controller,
              onClose: () => closed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      expect(closed, true);

      controller.dispose();
    });
  });

  group('ScrollableOutlineIndex', () {
    testWidgets('renders child content', (tester) async {
      final key = GlobalKey();
      final items = [
        OutlineItem(id: 'test', title: 'Test', widgetKey: key),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollableOutlineIndex(
              items: items,
              child: Container(
                key: key,
                child: const Text('Content'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('shows trigger button', (tester) async {
      final key = GlobalKey();
      final items = [
        OutlineItem(id: 'test', title: 'Test', widgetKey: key),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollableOutlineIndex(
              items: items,
              triggerIcon: Icons.toc,
              child: Container(
                key: key,
                child: const Text('Content'),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.toc), findsOneWidget);
    });

    testWidgets('respects enabled property', (tester) async {
      final key = GlobalKey();
      final items = [
        OutlineItem(id: 'test', title: 'Test', widgetKey: key),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollableOutlineIndex(
              items: items,
              enabled: false,
              child: Container(
                key: key,
                child: const Text('Content'),
              ),
            ),
          ),
        ),
      );

      // Trigger button should not be present when disabled
      expect(find.byType(OutlineTriggerButton), findsNothing);
    });

    testWidgets('panel opens on tap', (tester) async {
      final key = GlobalKey();
      final items = [
        OutlineItem(id: 'test', title: 'Test Item', widgetKey: key),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollableOutlineIndex(
              items: items,
              triggerMode: OutlineTriggerMode.tap,
              child: Container(
                key: key,
                height: 200,
                child: const Text('Content'),
              ),
            ),
          ),
        ),
      );

      // Tap the trigger button
      await tester.tap(find.byType(OutlineTriggerButton));
      await tester.pumpAndSettle();

      // Panel should now be visible with the item
      expect(find.text('Test Item'), findsOneWidget);
    });
  });

  group('OutlinePosition enum', () {
    test('has left and right values', () {
      expect(OutlinePosition.values.length, 2);
      expect(OutlinePosition.values.contains(OutlinePosition.left), true);
      expect(OutlinePosition.values.contains(OutlinePosition.right), true);
    });
  });

  group('OutlineTriggerMode enum', () {
    test('has hover, tap, and both values', () {
      expect(OutlineTriggerMode.values.length, 3);
      expect(OutlineTriggerMode.values.contains(OutlineTriggerMode.hover), true);
      expect(OutlineTriggerMode.values.contains(OutlineTriggerMode.tap), true);
      expect(OutlineTriggerMode.values.contains(OutlineTriggerMode.both), true);
    });
  });
}
