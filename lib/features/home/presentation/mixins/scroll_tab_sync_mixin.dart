import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:getincoffee/features/home/cubit/home_cubit.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';

/// Mixin that provides scroll-to-tab synchronization functionality.
///
/// This mixin handles bidirectional synchronization between a scrollable list
/// and a TabBar, automatically updating the selected tab based on the visible
/// content and vice versa.
mixin ScrollTabSyncMixin<T extends StatefulWidget> on State<T> {
  /// The AutoScrollController used for the scrollable content
  AutoScrollController get scrollController;

  /// The search controller for filtering content
  TextEditingController get searchController;

  /// Flag to prevent scroll-triggered tab updates during programmatic scrolling
  bool get isTabClicked;
  set isTabClicked(bool value);

  DateTime? _lastScrollUpdate;
  List<ProductCategoryList>? _cachedCategoryList;
  String _lastSearchText = "";

  /// Sets up the scroll listener. Call this in initState.
  void initScrollSync() {
    scrollController.addListener(onScroll);
  }

  /// Removes the scroll listener. Call this in dispose.
  void disposeScrollSync() {
    scrollController.removeListener(onScroll);
  }

  /// The scroll listener that syncs the TabBar with visible content.
  void onScroll() {
    if (isTabClicked) return;

    // Throttle: only update every 150ms
    final now = DateTime.now();
    if (_lastScrollUpdate != null &&
        now.difference(_lastScrollUpdate!) <
            const Duration(milliseconds: 150)) {
      return;
    }
    _lastScrollUpdate = now;

    final cubit = HomeCubit.get(context);

    // Check for "All" section (index -2)
    final allRenderObject =
        scrollController.tagMap[-2]?.context.findRenderObject();
    if (allRenderObject is RenderBox) {
      final position = allRenderObject.localToGlobal(Offset.zero);
      if (position.dy >= 0 && position.dy <= 200) {
        if (cubit.secondtabController.index != 0) {
          cubit.secondtabController.animateTo(0);
        }
        return;
      }
    }

    // Check for "Popular" section (index -1)
    final popularRenderObject =
        scrollController.tagMap[-1]?.context.findRenderObject();
    if (popularRenderObject is RenderBox) {
      final position = popularRenderObject.localToGlobal(Offset.zero);
      if (position.dy >= 0 && position.dy <= 200) {
        if (cubit.secondtabController.index != 1) {
          cubit.secondtabController.animateTo(1);
        }
        return;
      }
    }

    // Cache category list to avoid recalculating on every scroll
    if (_cachedCategoryList == null ||
        _lastSearchText != searchController.text) {
      _cachedCategoryList =
          cubit.homemodel.getproductcategorylist(title: searchController.text);
      _lastSearchText = searchController.text;
    }

    // Find the first visible category
    for (int i = 0; i < _cachedCategoryList!.length; i++) {
      if (_cachedCategoryList![i].type == ProductCategoryListenum.category) {
        final renderObject =
            scrollController.tagMap[i]?.context.findRenderObject();
        if (renderObject is RenderBox) {
          final position = renderObject.localToGlobal(Offset.zero);
          // Check if category is in viewport (considering AppBar height)
          if (position.dy >= 0 && position.dy <= 200) {
            final category = _cachedCategoryList![i].item as BranchCategory;
            final categoryIndex =
                cubit.categories.indexWhere((c) => c.id == category.id);
            if (categoryIndex != -1) {
              final tabIndex =
                  categoryIndex + 2; // +2 for "All" and "Popular" tabs
              if (cubit.secondtabController.index != tabIndex) {
                cubit.secondtabController.animateTo(tabIndex);
              }
            }
            break; // Found visible category, stop searching
          }
        }
      }
    }
  }
}
