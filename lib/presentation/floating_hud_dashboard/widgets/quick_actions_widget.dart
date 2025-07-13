import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> actions;

  const QuickActionsWidget({
    Key? key,
    required this.actions,
  }) : super(key: key);

  @override
  State<QuickActionsWidget> createState() => _QuickActionsWidgetState();
}

class _QuickActionsWidgetState extends State<QuickActionsWidget> {
  late List<Map<String, dynamic>> _actions;

  @override
  void initState() {
    super.initState();
    _actions = List.from(widget.actions);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.primaryCyan,
          ),
        ),
        SizedBox(height: 3.h),
        ..._actions.map((action) => _buildActionCard(action)).toList(),
      ],
    );
  }

  Widget _buildActionCard(Map<String, dynamic> action) {
    return Container(
      width: 100.w,
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassmorphismDecoration,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryCyan.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: CustomIconWidget(
                  iconName: action["icon"] as String,
                  color: AppTheme.primaryCyan,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  action["title"] as String,
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
              ),
              if (action["type"] == "toggle")
                Switch(
                  value: action["isEnabled"] as bool,
                  onChanged: (value) {
                    setState(() {
                      action["isEnabled"] = value;
                    });
                    _handleToggleAction(action, value);
                  },
                ),
            ],
          ),
          if (action["type"] == "slider") ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                Text(
                  '0',
                  style: AppTheme.darkTheme.textTheme.bodySmall,
                ),
                Expanded(
                  child: Slider(
                    value: (action["value"] as num).toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '${(action["value"] as num).toInt()}%',
                    onChanged: (value) {
                      setState(() {
                        action["value"] = value.toInt();
                      });
                      _handleSliderAction(action, value);
                    },
                  ),
                ),
                Text(
                  '100',
                  style: AppTheme.darkTheme.textTheme.bodySmall,
                ),
              ],
            ),
            Text(
              '${(action["value"] as num).toInt()}%',
              style: AppTheme.dataTextStyle(
                fontSize: 16.sp,
                color: AppTheme.primaryCyan,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleToggleAction(Map<String, dynamic> action, bool value) {
    // Simulate voice command execution
    final String command = value
        ? 'Hey MAAHI, turn on ${action["title"]}'
        : 'Hey MAAHI, turn off ${action["title"]}';

    _showActionFeedback(command);
  }

  void _handleSliderAction(Map<String, dynamic> action, double value) {
    // Simulate voice command execution
    final String command =
        'Hey MAAHI, set ${action["title"]} to ${value.toInt()}%';

    _showActionFeedback(command);
  }

  void _showActionFeedback(String command) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Executed: $command'),
        backgroundColor: AppTheme.elevatedSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: AppTheme.primaryCyan,
          onPressed: () {},
        ),
      ),
    );
  }
}
