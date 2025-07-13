import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommandHistoryItemWidget extends StatelessWidget {
  final Map<String, dynamic> historyItem;
  final VoidCallback onDelete;

  const CommandHistoryItemWidget({
    Key? key,
    required this.historyItem,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = historyItem["success"] ?? false;
    final DateTime timestamp = historyItem["timestamp"] ?? DateTime.now();
    final String timeAgo = _getTimeAgo(timestamp);

    return Dismissible(
      key: Key(historyItem["id"].toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.errorRed,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: 'delete',
          color: AppTheme.textPrimary,
          size: 24,
        ),
      ),
      child: GestureDetector(
        onLongPress: () => _showOptionsBottomSheet(context),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.elevatedSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSuccess
                  ? AppTheme.successGreen.withValues(alpha: 0.3)
                  : AppTheme.errorRed.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with timestamp and status
              Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: isSuccess
                          ? AppTheme.successGreen.withValues(alpha: 0.2)
                          : AppTheme.errorRed.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: isSuccess ? 'check_circle' : 'error',
                        color: isSuccess
                            ? AppTheme.successGreen
                            : AppTheme.errorRed,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          timeAgo,
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryCyan.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            historyItem["category"] ?? "Unknown",
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.primaryCyan,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showOptionsBottomSheet(context),
                    icon: CustomIconWidget(
                      iconName: 'more_vert',
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              // Recognized text
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.deepCharcoal,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recognized:",
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      "\"${historyItem["recognizedText"] ?? "Unknown"}\"",
                      style: AppTheme.dataTextStyle(
                        fontSize: 14,
                        color: AppTheme.primaryCyan,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1.h),
              // Executed action
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.deepCharcoal,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Result:",
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      historyItem["executedAction"] ?? "No action recorded",
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: isSuccess
                            ? AppTheme.textPrimary
                            : AppTheme.errorRed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.elevatedSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildOptionTile(
              context,
              icon: 'edit',
              title: 'Edit Command',
              onTap: () {
                Navigator.pop(context);
                // Edit functionality
              },
            ),
            _buildOptionTile(
              context,
              icon: 'content_copy',
              title: 'Duplicate',
              onTap: () {
                Navigator.pop(context);
                // Duplicate functionality
              },
            ),
            _buildOptionTile(
              context,
              icon: 'share',
              title: 'Share',
              onTap: () {
                Navigator.pop(context);
                // Share functionality
              },
            ),
            _buildOptionTile(
              context,
              icon: 'favorite',
              title: 'Add to Favorites',
              onTap: () {
                Navigator.pop(context);
                // Add to favorites functionality
              },
            ),
            _buildOptionTile(
              context,
              icon: 'delete',
              title: 'Delete',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: isDestructive ? AppTheme.errorRed : AppTheme.textSecondary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
          color: isDestructive ? AppTheme.errorRed : AppTheme.textPrimary,
        ),
      ),
      onTap: onTap,
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else {
      return "${difference.inDays}d ago";
    }
  }
}
