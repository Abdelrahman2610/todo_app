import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/task_enums.dart';

/// Statistics Screen
/// Shows task completion statistics and breakdowns
class StatisticsScreen extends StatelessWidget {
  final List<Task> tasks;

  const StatisticsScreen({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = tasks.length;
    final completed = tasks.where((t) => t.isCompleted).length;
    final pending = total - completed;
    final completionRate = total > 0
        ? (completed / total * 100).toStringAsFixed(1)
        : '0.0';

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: total == 0
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overall stats
                  _buildStatCard(context, 'Overall Progress', [
                    _StatItem('Total Tasks', total.toString(), Icons.list_alt),
                    _StatItem(
                      'Completed',
                      completed.toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                    _StatItem(
                      'Pending',
                      pending.toString(),
                      Icons.pending,
                      Colors.orange,
                    ),
                    _StatItem(
                      'Completion Rate',
                      '$completionRate%',
                      Icons.trending_up,
                      Colors.blue,
                    ),
                  ]),
                  const SizedBox(height: 16),

                  // Progress bar
                  _buildProgressBar(context, completed, total),
                  const SizedBox(height: 24),

                  // By priority
                  _buildStatCard(
                    context,
                    'By Priority',
                    TaskPriority.values.map((priority) {
                      final count = tasks
                          .where((t) => t.priority == priority)
                          .length;
                      final completedCount = tasks
                          .where((t) => t.priority == priority && t.isCompleted)
                          .length;
                      return _StatItem(
                        priority.displayName,
                        '$completedCount / $count',
                        priority.icon,
                        priority.color,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // By category
                  _buildStatCard(
                    context,
                    'By Category',
                    TaskCategory.values.map((category) {
                      final count = tasks
                          .where((t) => t.category == category)
                          .length;
                      final completedCount = tasks
                          .where((t) => t.category == category && t.isCompleted)
                          .length;
                      return _StatItem(
                        category.displayName,
                        '$completedCount / $count',
                        category.icon,
                        category.color,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Due date stats
                  _buildDueDateStats(context),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No Statistics Yet',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add tasks to see your statistics',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    List<_StatItem> items,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Icon(item.icon, color: item.color, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.label,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Text(
                          item.value,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: item.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, int completed, int total) {
    final progress = total > 0 ? completed / total : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Completion Progress',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 20,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress < 0.3
                      ? Colors.red
                      : progress < 0.7
                      ? Colors.orange
                      : Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$completed out of $total tasks completed',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDueDateStats(BuildContext context) {
    final overdue = tasks.where((t) => t.isOverdue).length;
    final dueSoon = tasks.where((t) => t.isDueSoon).length;
    final withDueDate = tasks.where((t) => t.dueDate != null).length;

    return _buildStatCard(context, 'Due Dates', [
      _StatItem('With Due Date', withDueDate.toString(), Icons.calendar_today),
      _StatItem('Due Soon', dueSoon.toString(), Icons.warning, Colors.orange),
      _StatItem('Overdue', overdue.toString(), Icons.error, Colors.red),
    ]);
  }
}

class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  _StatItem(this.label, this.value, this.icon, [this.color]);
}
