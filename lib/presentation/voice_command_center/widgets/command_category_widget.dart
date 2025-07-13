import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommandCategoryWidget extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onToggleExpansion;

  const CommandCategoryWidget({
    Key? key,
    required this.category,
    required this.onToggleExpansion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isExpanded = category["isExpanded"] ?? false;
    final List<dynamic> commands = category["commands"] ?? [];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          // Category Header
          InkWell(
            onTap: onToggleExpansion,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryCyan.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: category["icon"] ?? "category",
                        color: AppTheme.primaryCyan,
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
                          category["title"] ?? "Unknown Category",
                          style: AppTheme.darkTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          "${commands.length} commands available",
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Success indicator
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${_getSuccessCount(commands)}/${commands.length}",
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.textSecondary,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          // Expanded Commands List
          if (isExpanded) ...[
            Divider(color: AppTheme.borderColor, height: 1),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(4.w),
              itemCount: commands.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final command = commands[index];
                return _buildCommandItem(command);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommandItem(Map<String, dynamic> command) {
    final bool isSuccess = command["success"] ?? false;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.deepCharcoal,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSuccess
              ? AppTheme.successGreen.withValues(alpha: 0.3)
              : AppTheme.errorRed.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: isSuccess
                  ? AppTheme.successGreen.withValues(alpha: 0.2)
                  : AppTheme.errorRed.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: isSuccess ? 'check' : 'close',
                color: isSuccess ? AppTheme.successGreen : AppTheme.errorRed,
                size: 16,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\"${command["phrase"] ?? "Unknown command"}\"",
                  style: AppTheme.dataTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryCyan,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  command["description"] ?? "No description",
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  // Edit command
                },
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.textSecondary,
                  size: 18,
                ),
                constraints: BoxConstraints(
                  minWidth: 8.w,
                  minHeight: 8.w,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Test command
                },
                icon: CustomIconWidget(
                  iconName: 'play_arrow',
                  color: AppTheme.primaryCyan,
                  size: 18,
                ),
                constraints: BoxConstraints(
                  minWidth: 8.w,
                  minHeight: 8.w,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getSuccessCount(List<dynamic> commands) {
    return commands.where((command) => command["success"] == true).length;
  }
}
