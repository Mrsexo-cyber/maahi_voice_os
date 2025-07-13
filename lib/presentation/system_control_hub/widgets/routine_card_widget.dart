import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoutineCardWidget extends StatelessWidget {
  final Map<String, dynamic> routine;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  const RoutineCardWidget({
    Key? key,
    required this.routine,
    required this.onToggle,
    required this.onEdit,
  }) : super(key: key);

  Color get _statusColor {
    if (routine["isActive"] as bool) {
      return AppTheme.successGreen;
    }
    return AppTheme.textSecondary;
  }

  String get _triggerIcon {
    final trigger = routine["trigger"] as String;
    if (trigger.contains("AM") || trigger.contains("PM")) {
      return 'schedule';
    } else if (trigger.contains("Voice")) {
      return 'mic';
    } else if (trigger.contains("App")) {
      return 'apps';
    }
    return 'settings';
  }

  String _formatLastExecuted() {
    final lastExecuted = routine["last_executed"] as DateTime?;
    if (lastExecuted == null) {
      return 'Never executed';
    }

    final now = DateTime.now();
    final difference = now.difference(lastExecuted);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
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
          // Header with title and toggle
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: _triggerIcon,
                  color: _statusColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine["name"] as String,
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      routine["trigger"] as String,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: _statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: routine["isActive"] as bool,
                onChanged: (value) => onToggle(),
                activeColor: AppTheme.successGreen,
                inactiveThumbColor: AppTheme.textSecondary,
                inactiveTrackColor: AppTheme.borderColor,
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Description
          Text(
            routine["description"] as String,
            style: AppTheme.darkTheme.textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 2.h),

          // Voice trigger
          if (routine["voice_trigger"] != null)
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryCyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryCyan.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'mic',
                    color: AppTheme.primaryCyan,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      '"${routine["voice_trigger"]}"',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryCyan,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 2.h),

          // Actions preview
          if (routine["actions"] != null)
            Wrap(
              spacing: 1.w,
              runSpacing: 0.5.h,
              children: (routine["actions"] as List).take(3).map((action) {
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.w),
                  decoration: BoxDecoration(
                    color: AppTheme.elevatedSurface,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getActionLabel(action as String),
                    style: AppTheme.darkTheme.textTheme.labelSmall,
                  ),
                );
              }).toList(),
            ),

          SizedBox(height: 2.h),

          // Footer with last executed and edit button
          Row(
            children: [
              Expanded(
                child: Text(
                  'Last: ${_formatLastExecuted()}',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
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
            ],
          ),
        ],
      ),
    );
  }

  String _getActionLabel(String action) {
    switch (action) {
      case 'wifi_on':
        return 'Wi-Fi On';
      case 'wifi_off':
        return 'Wi-Fi Off';
      case 'brightness_80':
        return 'Brightness 80%';
      case 'brightness_20':
        return 'Brightness 20%';
      case 'brightness_100':
        return 'Max Brightness';
      case 'notifications_on':
        return 'Notifications On';
      case 'dnd_on':
        return 'DND On';
      case 'performance_mode':
        return 'Performance Mode';
      case 'performance_max':
        return 'Max Performance';
      case 'block_social':
        return 'Block Social Apps';
      default:
        return action.replaceAll('_', ' ').toUpperCase();
    }
  }
}
