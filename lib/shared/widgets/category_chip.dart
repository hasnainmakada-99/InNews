import 'package:flutter/material.dart';
import '../models/news_category.dart';
import '../../core/theme/app_theme.dart';

class CategoryChip extends StatelessWidget {
  final NewsCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 16,
              color: isSelected 
                  ? Colors.white 
                  : category.color,
            ),
            const SizedBox(width: 6),
            Text(
              category.displayName,
              style: TextStyle(
                color: isSelected 
                    ? Colors.white 
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected 
                    ? FontWeight.w600 
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: theme.colorScheme.surface,
        selectedColor: category.color,
        checkmarkColor: Colors.white,
        side: BorderSide(
          color: isSelected 
              ? category.color 
              : theme.colorScheme.outline.withOpacity(0.3),
        ),
        elevation: isSelected ? 2 : 0,
        pressElevation: 4,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  final NewsCategory? selectedCategory;
  final Function(NewsCategory?) onCategorySelected;

  const CategoryList({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // All categories chip
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.all_inclusive,
                    size: 16,
                    color: selectedCategory == null 
                        ? Colors.white 
                        : AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'All',
                    style: TextStyle(
                      color: selectedCategory == null 
                          ? Colors.white 
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: selectedCategory == null 
                          ? FontWeight.w600 
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
              selected: selectedCategory == null,
              onSelected: (_) => onCategorySelected(null),
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: AppTheme.primaryColor,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: selectedCategory == null 
                    ? AppTheme.primaryColor 
                    : Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
              elevation: selectedCategory == null ? 2 : 0,
              pressElevation: 4,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          
          // Category chips
          ...NewsCategory.values.map(
            (category) => CategoryChip(
              category: category,
              isSelected: selectedCategory == category,
              onTap: () => onCategorySelected(category),
            ),
          ),
        ],
      ),
    );
  }
}