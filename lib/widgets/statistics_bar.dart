import 'package:flutter/material.dart';
import '../models/task_model.dart';

class StatisticsBar extends StatelessWidget {
  final List<TaskModel> tasks;

  const StatisticsBar({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    int total = tasks.length;
    int done = tasks.where((t) => t.isDone).length;
    int pending = total - done;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.list_alt,
            label: "Total",
            count: total,
            color: Colors.blueAccent,
          ),
          _buildStatItem(
            icon: Icons.check_circle,
            label: "Selesai",
            count: done,
            color: Colors.green,
          ),
          _buildStatItem(
            icon: Icons.pending_actions,
            label: "Belum",
            count: pending,
            color: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: color.withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
