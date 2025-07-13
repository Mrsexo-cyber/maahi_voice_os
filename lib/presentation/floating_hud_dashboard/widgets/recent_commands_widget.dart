import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentCommandsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> commands;

  const RecentCommandsWidget({
    Key? key,
    required this.commands,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Commands',
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryCyan,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to full command history
              },
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        if (commands.isEmpty)
          _buildEmptyState()
        else
          ...commands.map((command) => _buildCommandCard(command)).toList(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: 100.w,
      padding: EdgeInsets.all(8.w),
      decoration: AppTheme.glassmorphismDecoration,
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'mic_off',
            color: AppTheme.textSecondary,
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No recent commands',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Say "Hey MAAHI" to start giving voice commands',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCommandCard(Map<String, dynamic> command) {
    return Container(
      width: 100.w,
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassmorphismDecoration,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: _getStatusColor(command["status"] as String)
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: CustomIconWidget(
              iconName: _getStatusIcon(command["status"] as String),
              color: _getStatusColor(command["status"] as String),
              size: 5.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  command["command"] as String,
                  style: AppTheme.darkTheme.textTheme.bodyLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      command["timestamp"] as String,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(command["status"] as String)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(1.w),
                      ),
                      child: Text(
                        (command["status"] as String).toUpperCase(),
                        style:
                            AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                          color: _getStatusColor(command["status"] as String),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _showCommandDetails(command);
            },
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.textSecondary,
              size: 5.w,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'check_circle';
      case 'failed':
        return 'error';
      case 'pending':
        return 'schedule';
      default:
        return 'help';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppTheme.successGreen;
      case 'failed':
        return AppTheme.errorRed;
      case 'pending':
        return AppTheme.warningAmber;
      default:
        return AppTheme.textSecondary;
    }
  }

  void _showCommandDetails(Map<String, dynamic> command) {
    // Show command details in a bottom sheet or dialog
  }
}
