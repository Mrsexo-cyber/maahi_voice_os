import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActiveRoutinesWidget extends StatefulWidget {
  final List<Map<String, dynamic>> routines;

  const ActiveRoutinesWidget({
    Key? key,
    required this.routines,
  }) : super(key: key);

  @override
  State<ActiveRoutinesWidget> createState() => _ActiveRoutinesWidgetState();
}

class _ActiveRoutinesWidgetState extends State<ActiveRoutinesWidget> {
  late List<Map<String, dynamic>> _routines;

  @override
  void initState() {
    super.initState();
    _routines = List.from(widget.routines);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Routines',
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryCyan,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                _showCreateRoutineDialog();
              },
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.primaryCyan,
                size: 5.w,
              ),
              label: Text('Create'),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        if (_routines.isEmpty)
          _buildEmptyState()
        else
          ..._routines.map((routine) => _buildRoutineCard(routine)).toList(),
        SizedBox(height: 3.h),
        _buildSuggestedRoutines(),
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
            iconName: 'auto_awesome',
            color: AppTheme.textSecondary,
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No active routines',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Create routines to automate your daily tasks with voice commands',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineCard(Map<String, dynamic> routine) {
    final bool isActive = routine["isActive"] as bool;

    return Container(
      width: 100.w,
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.primaryCyan.withValues(alpha: 0.1)
            : AppTheme.elevatedSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? AppTheme.primaryCyan : AppTheme.borderColor,
          width: isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? AppTheme.primaryCyan.withValues(alpha: 0.2)
                : AppTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppTheme.primaryCyan.withValues(alpha: 0.2)
                      : AppTheme.borderColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: CustomIconWidget(
                  iconName: _getRoutineIcon(routine["name"] as String),
                  color:
                      isActive ? AppTheme.primaryCyan : AppTheme.textSecondary,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine["name"] as String,
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: isActive
                            ? AppTheme.primaryCyan
                            : AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      routine["description"] as String,
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isActive,
                onChanged: (value) {
                  setState(() {
                    routine["isActive"] = value;
                  });
                  _toggleRoutine(routine, value);
                },
              ),
            ],
          ),
          if (isActive) ...[
            SizedBox(height: 2.h),
            Container(
              width: 100.w,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryCyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.primaryCyan,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Routine is currently active',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryCyan,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestedRoutines() {
    final List<Map<String, dynamic>> suggestions = [
      {
        "name": "Focus Mode",
        "description": "Block distracting apps and notifications",
        "icon": "psychology",
      },
      {
        "name": "Sleep Mode",
        "description": "Dim lights, enable DND, set alarms",
        "icon": "bedtime",
      },
      {
        "name": "Workout Mode",
        "description": "Play music, track fitness, motivate",
        "icon": "fitness_center",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggested Routines',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.tealAccent,
          ),
        ),
        SizedBox(height: 2.h),
        ...suggestions
            .map((suggestion) => _buildSuggestionCard(suggestion))
            .toList(),
      ],
    );
  }

  Widget _buildSuggestionCard(Map<String, dynamic> suggestion) {
    return Container(
      width: 100.w,
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: suggestion["icon"] as String,
            color: AppTheme.tealAccent,
            size: 6.w,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion["name"] as String,
                  style: AppTheme.darkTheme.textTheme.titleSmall,
                ),
                Text(
                  suggestion["description"] as String,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              _createRoutineFromSuggestion(suggestion);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.tealAccent),
              foregroundColor: AppTheme.tealAccent,
            ),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  String _getRoutineIcon(String routineName) {
    switch (routineName.toLowerCase()) {
      case 'study mode':
        return 'school';
      case 'gaming mode':
        return 'sports_esports';
      case 'focus mode':
        return 'psychology';
      case 'sleep mode':
        return 'bedtime';
      case 'workout mode':
        return 'fitness_center';
      default:
        return 'auto_awesome';
    }
  }

  void _toggleRoutine(Map<String, dynamic> routine, bool isActive) {
    final String action = isActive ? 'activated' : 'deactivated';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${routine["name"]} routine $action'),
        backgroundColor: AppTheme.elevatedSurface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _createRoutineFromSuggestion(Map<String, dynamic> suggestion) {
    setState(() {
      _routines.add({
        "id": _routines.length + 1,
        "name": suggestion["name"],
        "description": suggestion["description"],
        "isActive": false,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${suggestion["name"]} routine created'),
        backgroundColor: AppTheme.elevatedSurface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCreateRoutineDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create New Routine'),
        content: Text('Voice command: "Hey MAAHI, create a new routine"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to routine builder
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }
}
