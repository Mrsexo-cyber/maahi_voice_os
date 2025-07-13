import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScheduledTaskWidget extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  const ScheduledTaskWidget({
    Key? key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
  }) : super(key: key);

  Color get _statusColor {
    if (task["isEnabled"] as bool) {
      return AppTheme.primaryCyan;
    }
    return AppTheme.textSecondary;
  }

  String get _typeIcon {
    final type = task["type"] as String;
    switch (type) {
      case 'maintenance':
        return 'build';
      case 'backup':
        return 'backup';
      case 'conditional':
        return 'rule';
      default:
        return 'schedule';
    }
  }

  Color get _typeColor {
    final type = task["type"] as String;
    switch (type) {
      case 'maintenance':
        return AppTheme.warningAmber;
      case 'backup':
        return AppTheme.successGreen;
      case 'conditional':
        return AppTheme.primaryCyan;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _formatNextRun() {
    final nextRun = task["next_run"] as DateTime?;
    if (nextRun == null) {
      return 'On condition';
    }

    final now = DateTime.now();
    final difference = nextRun.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    } else if (difference.inMinutes < 60) {
      return 'In ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'In ${difference.inHours}h ${difference.inMinutes % 60}m';
    } else {
      return 'In ${difference.inDays}d ${difference.inHours % 24}h';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.deepCharcoal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _statusColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with type icon, title and toggle
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: _typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: _typeIcon,
                  color: _typeColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task["title"] as String,
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      task["type"].toString().toUpperCase(),
                      style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                        color: _typeColor,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: task["isEnabled"] as bool,
                onChanged: (value) => onToggle(),
                activeColor: AppTheme.primaryCyan,
                inactiveThumbColor: AppTheme.textSecondary,
                inactiveTrackColor: AppTheme.borderColor,
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Description
          Text(
            task["description"] as String,
            style: AppTheme.darkTheme.textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 2.h),

          // Schedule information
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.elevatedSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.primaryCyan,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Schedule: ${task["schedule"]}',
                        style: AppTheme.darkTheme.textTheme.bodySmall,
                      ),
                      Text(
                        'Next run: ${_formatNextRun()}',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryCyan,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Footer with status and edit button
          Row(
            children: [
              // Status indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: _statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      task["isEnabled"] as bool ? 'Active' : 'Disabled',
                      style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                        color: _statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Edit button
              TextButton.icon(
                onPressed: onEdit,
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.primaryCyan,
                  size: 16,
                ),
                label: Text(
                  'Edit',
                  style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.primaryCyan,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  minimumSize: Size.zero,
                ),
              ),
              // Run now button (for enabled tasks)
              if (task["isEnabled"] as bool)
                TextButton.icon(
                  onPressed: () {
                    // Implement run now functionality
                  },
                  icon: CustomIconWidget(
                    iconName: 'play_arrow',
                    color: AppTheme.successGreen,
                    size: 16,
                  ),
                  label: Text(
                    'Run Now',
                    style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.successGreen,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                    minimumSize: Size.zero,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
