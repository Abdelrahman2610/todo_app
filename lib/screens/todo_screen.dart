import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/task_enums.dart';
import '../widgets/task_tile.dart';
import '../widgets/add_task_input.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/filter_chips.dart';
import '../widgets/task_detail_dialog.dart';
import 'statistics_screen.dart';

/// Enhanced TodoScreen with All Features
class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen>
    with SingleTickerProviderStateMixin {
  // Task storage
  List<Task> _tasks = [];

  // Search and filter
  String _searchQuery = '';
  TaskCategory? _selectedCategory;
  TaskPriority? _selectedPriority;
  SortOption _sortOption = SortOption.dateAdded;
  bool _showFilters = false;

  // Animation controller for adding tasks
  late AnimationController _addAnimationController;

  @override
  void initState() {
    super.initState();
    _addAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _addAnimationController.dispose();
    super.dispose();
  }

  /// Add or update task
  void _saveTask(
    String title,
    TaskPriority priority,
    TaskCategory category,
    String notes,
    DateTime? dueDate, {
    Task? existingTask,
  }) {
    setState(() {
      if (existingTask != null) {
        // Update existing task
        _tasks = _tasks.map((t) {
          if (t.id == existingTask.id) {
            return Task(
              title: title,
              priority: priority,
              category: category,
              notes: notes,
              dueDate: dueDate,
              isCompleted: t.isCompleted,
            );
          }
          return t;
        }).toList();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task updated'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        // Add new task
        _tasks.add(
          Task(
            title: title,
            priority: priority,
            category: category,
            notes: notes,
            dueDate: dueDate,
          ),
        );

        _addAnimationController.forward().then(
          (_) => _addAnimationController.reverse(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task "$title" added'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  /// Show add/edit task dialog
  void _showTaskDialog({Task? task}) {
    showDialog(
      context: context,
      builder: (context) => TaskDetailDialog(
        task: task,
        onSave: (title, priority, category, notes, dueDate) {
          _saveTask(
            title,
            priority,
            category,
            notes,
            dueDate,
            existingTask: task,
          );
        },
      ),
    );
  }

  /// Toggle task completion
  void _toggleTask(String taskId) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == taskId);
      task.toggleCompleted();
    });
  }

  /// Delete task
  void _deleteTask(String taskId) {
    setState(() {
      _tasks.removeWhere((task) => task.id == taskId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task deleted'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// Clear completed tasks
  void _clearCompleted() {
    final completedCount = _tasks.where((task) => task.isCompleted).length;

    if (completedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No completed tasks to clear'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Completed Tasks'),
          content: Text(
            'Delete $completedCount completed task${completedCount > 1 ? 's' : ''}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _tasks.removeWhere((task) => task.isCompleted);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '$completedCount task${completedCount > 1 ? 's' : ''} cleared',
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  /// Get filtered and sorted tasks
  List<Task> get _filteredTasks {
    var filtered = _tasks.where((task) {
      // Search filter
      final matchesSearch =
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.notes.toLowerCase().contains(_searchQuery.toLowerCase());

      // Category filter
      final matchesCategory =
          _selectedCategory == null || task.category == _selectedCategory;

      // Priority filter
      final matchesPriority =
          _selectedPriority == null || task.priority == _selectedPriority;

      return matchesSearch && matchesCategory && matchesPriority;
    }).toList();

    // Apply sorting
    switch (_sortOption) {
      case SortOption.alphabetical:
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.priority:
        filtered.sort((a, b) => a.priority.index.compareTo(b.priority.index));
        break;
      case SortOption.category:
        filtered.sort((a, b) => a.category.index.compareTo(b.category.index));
        break;
      case SortOption.dueDate:
        filtered.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case SortOption.dateAdded:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return filtered;
  }

  /// Get stats text
  String _getStatsText() {
    final total = _tasks.length;
    final completed = _tasks.where((task) => task.isCompleted).length;
    final pending = total - completed;

    if (total == 0) return 'No tasks yet';
    return '$pending pending • $completed completed';
  }

  /// Show sort options
  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Sort By',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...SortOption.values.map((option) {
              return ListTile(
                title: Text(option.displayName),
                trailing: _sortOption == option
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    _sortOption = option;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  /// Navigate to statistics
  void _openStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StatisticsScreen(tasks: _tasks)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filteredTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My To-Do List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Statistics button
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Statistics',
            onPressed: _openStatistics,
          ),
          // Sort button
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort',
            onPressed: _showSortOptions,
          ),
          // Filter toggle
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
            ),
            tooltip: 'Filters',
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
          // Clear completed
          if (_tasks.any((task) => task.isCompleted))
            IconButton(
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear completed',
              onPressed: _clearCompleted,
            ),
        ],
      ),
      body: Column(
        children: [
          // Stats banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Text(
              _getStatsText(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Search bar
          SearchBarWidget(
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
          ),

          // Filters (collapsible)
          if (_showFilters)
            FilterChips(
              selectedCategory: _selectedCategory,
              selectedPriority: _selectedPriority,
              onCategoryChanged: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              onPriorityChanged: (priority) {
                setState(() {
                  _selectedPriority = priority;
                });
              },
            ),

          // Task list
          Expanded(
            child: filteredTasks.isEmpty
                ? _buildEmptyState()
                : ReorderableListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    itemCount: filteredTasks.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final task = filteredTasks.removeAt(oldIndex);
                        filteredTasks.insert(newIndex, task);
                        _tasks = filteredTasks;
                      });
                    },
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Dismissible(
                        key: Key(task.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Task'),
                                content: const Text('Are you sure?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          _deleteTask(task.id);
                        },
                        child: TaskTile(
                          key: ValueKey(task.id),
                          task: task,
                          onToggle: () => _toggleTask(task.id),
                          onDelete: () => _deleteTask(task.id),
                          onEdit: () => _showTaskDialog(task: task),
                        ),
                      );
                    },
                  ),
          ),

          // Add task input
          AddTaskInput(onAddPressed: () => _showTaskDialog()),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty ||
                    _selectedCategory != null ||
                    _selectedPriority != null
                ? 'No matching tasks'
                : 'No tasks yet',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty ||
                    _selectedCategory != null ||
                    _selectedPriority != null
                ? 'Try adjusting your filters'
                : 'Tap below to add your first task',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
