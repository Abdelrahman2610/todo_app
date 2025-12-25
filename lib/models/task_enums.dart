import 'package:flutter/material.dart';

/// Task Priority Levels
enum TaskPriority {
  high,
  medium,
  low;

  /// Get display name
  String get displayName {
    switch (this) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  /// Get priority color
  Color get color {
    switch (this) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  /// Get priority icon
  IconData get icon {
    switch (this) {
      case TaskPriority.high:
        return Icons.priority_high;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.low:
        return Icons.arrow_downward;
    }
  }
}

/// Task Categories
enum TaskCategory {
  work,
  personal,
  shopping,
  health,
  study;

  /// Get display name
  String get displayName {
    switch (this) {
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.shopping:
        return 'Shopping';
      case TaskCategory.health:
        return 'Health';
      case TaskCategory.study:
        return 'Study';
    }
  }

  /// Get category color
  Color get color {
    switch (this) {
      case TaskCategory.work:
        return Colors.blue;
      case TaskCategory.personal:
        return Colors.purple;
      case TaskCategory.shopping:
        return Colors.teal;
      case TaskCategory.health:
        return Colors.pink;
      case TaskCategory.study:
        return Colors.indigo;
    }
  }

  /// Get category icon
  IconData get icon {
    switch (this) {
      case TaskCategory.work:
        return Icons.work_outline;
      case TaskCategory.personal:
        return Icons.person_outline;
      case TaskCategory.shopping:
        return Icons.shopping_cart_outlined;
      case TaskCategory.health:
        return Icons.favorite_outline;
      case TaskCategory.study:
        return Icons.school_outlined;
    }
  }
}

/// Sort Options
enum SortOption {
  dateAdded,
  alphabetical,
  priority,
  category,
  dueDate;

  String get displayName {
    switch (this) {
      case SortOption.dateAdded:
        return 'Date Added';
      case SortOption.alphabetical:
        return 'Alphabetical';
      case SortOption.priority:
        return 'Priority';
      case SortOption.category:
        return 'Category';
      case SortOption.dueDate:
        return 'Due Date';
    }
  }
}
