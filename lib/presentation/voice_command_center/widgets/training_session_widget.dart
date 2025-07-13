import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrainingSessionWidget extends StatelessWidget {
  final Map<String, dynamic> session;
  final VoidCallback onStart;

  const TrainingSessionWidget({
    Key? key,
    required this.session,
    required this.onStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progress = session["progress"]?.toDouble() ?? 0.0;
    final bool isCompleted = session["isCompleted"] ?? false;
    final String estimatedTime = session["estimatedTime"] ?? "Unknown";

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? AppTheme.successGreen.withValues(alpha: 0.3)
              : AppTheme.borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.successGreen.withValues(alpha: 0.2)
                      : AppTheme.primaryCyan.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: isCompleted ? 'check_circle' : 'school',
                    color: isCompleted
                        ? AppTheme.successGreen
                        : AppTheme.primaryCyan,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session["title"] ?? "Unknown Session",
                      style: AppTheme.darkTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: AppTheme.textSecondary,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          estimatedTime,
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Completed",
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.successGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          // Description
          Text(
            session["description"] ?? "No description available",
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Progress",
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${(progress * 100).toInt()}%",
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: isCompleted
                          ? AppTheme.successGreen
                          : AppTheme.primaryCyan,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Container(
                width: double.infinity,
                height: 1.h,
                decoration: BoxDecoration(
                  color: AppTheme.borderColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppTheme.successGreen
                          : AppTheme.primaryCyan,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          // Action buttons
          Row(
            children: [
              if (!isCompleted) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: onStart,
                    child: Text(progress > 0 ? "Continue" : "Start"),
                  ),
                ),
                SizedBox(width: 3.w),
              ],
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showSessionDetails(context),
                  icon: CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.trueDarkBackground,
                    size: 18,
                  ),
                  label: Text("Details"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSessionDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.elevatedSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 10.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                session["title"] ?? "Training Session",
                style: AppTheme.darkTheme.textTheme.headlineSmall,
              ),
              SizedBox(height: 2.h),
              Text(
                session["description"] ?? "No description available",
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 3.h),
              _buildDetailItem(
                icon: 'schedule',
                title: 'Estimated Time',
                value: session["estimatedTime"] ?? "Unknown",
              ),
              SizedBox(height: 2.h),
              _buildDetailItem(
                icon: 'trending_up',
                title: 'Progress',
                value: "${((session["progress"] ?? 0.0) * 100).toInt()}%",
              ),
              SizedBox(height: 2.h),
              _buildDetailItem(
                icon: 'check_circle',
                title: 'Status',
                value: (session["isCompleted"] ?? false)
                    ? "Completed"
                    : "In Progress",
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onStart();
                  },
                  child: Text(
                    (session["isCompleted"] ?? false)
                        ? "Review Session"
                        : "Start Training",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required String icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.deepCharcoal,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.primaryCyan,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: AppTheme.darkTheme.textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryCyan,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
