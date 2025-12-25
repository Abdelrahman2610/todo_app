import 'task_enums.dart';

/// Enhanced Task Model
/// Represents a to-do task with priority, category, notes, and due date
class Task {
  final String id;
  final String title;
  bool isCompleted;

  // New fields
  final TaskPriority priority;
  final TaskCategory category;
  String notes;
  DateTime? dueDate;
  final DateTime createdAt;

  /// Constructor
  Task({
    required this.title,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    this.category = TaskCategory.personal,
    this.notes = '',
    this.dueDate,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString(),
       createdAt = DateTime.now();

  /// Toggle completion status
  void toggleCompleted() {
    isCompleted = !isCompleted;
  }

  /// Check if task is overdue
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// Get days until due date
  int? get daysUntilDue {
    if (dueDate == null) return null;
    final difference = dueDate!.difference(DateTime.now()).inDays;
    return difference;
  }

  /// Check if due soon (within 3 days)
  bool get isDueSoon {
    final days = daysUntilDue;
    if (days == null || isCompleted) return false;
    return days >= 0 && days <= 3;
  }
}
