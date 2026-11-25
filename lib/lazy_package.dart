// lib/lazy_widgets.dart

import 'package:flutter/material.dart';

/// LazyColumn - Vertical scrollable list with lazy loading
/// 
/// Accepts both Widget and Widget Function() for flexibility.
/// Use () => Widget() for expensive widgets that should load lazily.
/// Use Widget() directly for simple, cheap widgets.
/// 
/// Example:
/// ```dart
/// LazyColumn(
///   children: [
///     Text('Simple'),              // Not lazy
///     () => ExpensiveWidget(),     // Lazy
///   ],
/// )
/// ```
class LazyColumn extends StatelessWidget {
  final List<dynamic> children;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final ScrollController? controller;

  const LazyColumn({
    required this.children,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      physics: physics,
      padding: padding,
      shrinkWrap: shrinkWrap,
      itemCount: children.length,
      itemBuilder: (context, index) {
        final child = children[index];
        return child is Widget Function() ? child() : child as Widget;
      },
    );
  }
}

/// LazyRow - Horizontal scrollable list with lazy loading
/// 
/// Accepts both Widget and Widget Function() for flexibility.
/// 
/// Example:
/// ```dart
/// LazyRow(
///   children: [
///     Icon(Icons.star),           // Not lazy
///     () => ExpensiveWidget(),    // Lazy
///   ],
/// )
/// ```
class LazyRow extends StatelessWidget {
  final List<dynamic> children;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  const LazyRow({
    required this.children,
    this.padding,
    this.physics,
    this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      scrollDirection: Axis.horizontal,
      physics: physics,
      padding: padding,
      itemCount: children.length,
      itemBuilder: (context, index) {
        final child = children[index];
        return child is Widget Function() ? child() : child as Widget;
      },
    );
  }
}

/// LazySliverList - Sliver list with lazy loading
/// 
/// Use inside CustomScrollView.
/// Accepts both Widget and Widget Function() for flexibility.
/// 
/// Example:
/// ```dart
/// CustomScrollView(
///   slivers: [
///     LazySliverList(
///       children: [
///         Text('Simple'),            // Not lazy
///         () => ExpensiveWidget(),   // Lazy
///       ],
///     ),
///   ],
/// )
/// ```
class LazySliverList extends StatelessWidget {
  final List<dynamic> children;

  const LazySliverList({
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final child = children[index];
          return child is Widget Function() ? child() : child as Widget;
        },
        childCount: children.length,
      ),
    );
  }
}

/// LazySliverGrid - Sliver grid with lazy loading
/// 
/// Use inside CustomScrollView.
/// Accepts both Widget and Widget Function() for flexibility.
/// 
/// Example:
/// ```dart
/// CustomScrollView(
///   slivers: [
///     LazySliverGrid(
///       crossAxisCount: 2,
///       children: [
///         Icon(Icons.star),          // Not lazy
///         () => ExpensiveWidget(),   // Lazy
///       ],
///     ),
///   ],
/// )
/// ```
class LazySliverGrid extends StatelessWidget {
  final List<dynamic> children;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  const LazySliverGrid({
    required this.children,
    required this.crossAxisCount,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final child = children[index];
          return child is Widget Function() ? child() : child as Widget;
        },
        childCount: children.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
    );
  }
}

/// LazyGrid - Grid view with lazy loading
/// 
/// Accepts both Widget and Widget Function() for flexibility.
/// 
/// Example:
/// ```dart
/// LazyGrid(
///   crossAxisCount: 2,
///   children: [
///     Icon(Icons.star),          // Not lazy
///     () => ExpensiveWidget(),   // Lazy
///   ],
/// )
/// ```
class LazyGrid extends StatelessWidget {
  final List<dynamic> children;
  final int crossAxisCount;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final bool shrinkWrap;
  final ScrollController? controller;

  const LazyGrid({
    required this.children,
    required this.crossAxisCount,
    this.padding,
    this.physics,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1.0,
    this.shrinkWrap = false,
    this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      physics: physics,
      padding: padding,
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        final child = children[index];
        return child is Widget Function() ? child() : child as Widget;
      },
    );
  }
}

/// Helper function to make intent clear when creating lazy widgets
/// 
/// Example:
/// ```dart
/// LazyColumn(
///   children: [
///     lazy(() => ExpensiveWidget()),
///   ],
/// )
/// ```
Widget Function() lazy(Widget Function() builder) => builder;