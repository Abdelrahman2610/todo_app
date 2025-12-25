import 'package:flutter/material.dart';
import '../models/task_enums.dart';

/// Filter Chips Widget
/// Shows category and priority filters
class FilterChips extends StatelessWidget {
  final TaskCategory? selectedCategory;
  final TaskPriority? selectedPriority;
  final Function(TaskCategory?) onCategoryChanged;
  final Function(TaskPriority?) onPriorityChanged;

  const FilterChips({
    Key? key,
    required this.selectedCategory,
    required this.selectedPriority,
    required this.onCategoryChanged,
    required this.onPriorityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // All categories chip
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: const Text('All'),
                  selected: selectedCategory == null,
                  onSelected: (selected) {
                    onCategoryChanged(null);
                  },
                ),
              ),
              // Individual category chips
              ...TaskCategory.values.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(category.icon, size: 16),
                        const SizedBox(width: 4),
                        Text(category.displayName),
                      ],
                    ),
                    selected: selectedCategory == category,
                    onSelected: (selected) {
                      onCategoryChanged(selected ? category : null);
                    },
                    backgroundColor: category.color.withOpacity(0.1),
                    selectedColor: category.color.withOpacity(0.3),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Priority filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Priority',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // All priorities chip
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: const Text('All'),
                  selected: selectedPriority == null,
                  onSelected: (selected) {
                    onPriorityChanged(null);
                  },
                ),
              ),
              // Individual priority chips
              ...TaskPriority.values.map((priority) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(priority.icon, size: 16),
                        const SizedBox(width: 4),
                        Text(priority.displayName),
                      ],
                    ),
                    selected: selectedPriority == priority,
                    onSelected: (selected) {
                      onPriorityChanged(selected ? priority : null);
                    },
                    backgroundColor: priority.color.withOpacity(0.1),
                    selectedColor: priority.color.withOpacity(0.3),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
