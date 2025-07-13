import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './routine_card_widget.dart';
import './scheduled_task_widget.dart';

class AutomationTabWidget extends StatefulWidget {
  final Map<String, dynamic> systemStatus;

  const AutomationTabWidget({
    Key? key,
    required this.systemStatus,
  }) : super(key: key);

  @override
  State<AutomationTabWidget> createState() => _AutomationTabWidgetState();
}

class _AutomationTabWidgetState extends State<AutomationTabWidget> {
  final List<Map<String, dynamic>> _activeRoutines = [
    {
      "id": 1,
      "name": "Morning Routine",
      "description":
          "Turn on Wi-Fi, set brightness to 80%, enable notifications",
      "trigger": "7:00 AM",
      "isActive": true,
      "actions": ["wifi_on", "brightness_80", "notifications_on"],
      "voice_trigger": "good morning maahi",
      "last_executed": DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      "id": 2,
      "name": "Sleep Mode",
      "description": "Enable DND, dim brightness, turn off Wi-Fi",
      "trigger": "10:30 PM",
      "isActive": true,
      "actions": ["dnd_on", "brightness_20", "wifi_off"],
      "voice_trigger": "sleep mode on karo",
      "last_executed": DateTime.now().subtract(const Duration(hours: 10)),
    },
    {
      "id": 3,
      "name": "Study Focus",
      "description": "Block social apps, enable DND, optimize performance",
      "trigger": "Voice Command",
      "isActive": false,
      "actions": ["block_social", "dnd_on", "performance_mode"],
      "voice_trigger": "study mode start karo",
      "last_executed": null,
    },
    {
      "id": 4,
      "name": "Gaming Mode",
      "description": "Max brightness, performance mode, DND on",
      "trigger": "Gaming App Launch",
      "isActive": true,
      "actions": ["brightness_100", "performance_max", "dnd_on"],
      "voice_trigger": "gaming mode activate",
      "last_executed": DateTime.now().subtract(const Duration(hours: 5)),
    },
  ];

  final List<Map<String, dynamic>> _scheduledTasks = [
    {
      "id": 1,
      "title": "RAM Cleanup",
      "description": "Clean RAM memory automatically",
      "schedule": "Every 2 hours",
      "next_run": DateTime.now().add(const Duration(hours: 1, minutes: 30)),
      "isEnabled": true,
      "type": "maintenance",
    },
    {
      "id": 2,
      "title": "Storage Optimization",
      "description": "Clear cache and temporary files",
      "schedule": "Daily at 3:00 AM",
      "next_run": DateTime.now().add(const Duration(hours: 7)),
      "isEnabled": true,
      "type": "maintenance",
    },
    {
      "id": 3,
      "title": "Battery Optimization",
      "description": "Optimize battery usage and close background apps",
      "schedule": "When battery < 20%",
      "next_run": null,
      "isEnabled": true,
      "type": "conditional",
    },
    {
      "id": 4,
      "title": "Backup Voice Settings",
      "description": "Backup voice commands and preferences",
      "schedule": "Weekly on Sunday",
      "next_run": DateTime.now().add(const Duration(days: 3)),
      "isEnabled": false,
      "type": "backup",
    },
  ];

  void _toggleRoutine(int routineId) {
    setState(() {
      final routine = _activeRoutines.firstWhere((r) => r["id"] == routineId);
      routine["isActive"] = !(routine["isActive"] as bool);
    });
  }

  void _toggleTask(int taskId) {
    setState(() {
      final task = _scheduledTasks.firstWhere((t) => t["id"] == taskId);
      task["isEnabled"] = !(task["isEnabled"] as bool);
    });
  }

  void _showCreateRoutineDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.elevatedSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create New Routine',
                    style: AppTheme.darkTheme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 3.h),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Routine Name',
                      hintText: 'Enter routine name',
                    ),
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Voice Trigger',
                      hintText: 'e.g., "work mode start karo"',
                    ),
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Describe what this routine does',
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Actions',
                    style: AppTheme.darkTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: [
                      _buildActionChip('Wi-Fi On', 'wifi'),
                      _buildActionChip('DND On', 'do_not_disturb'),
                      _buildActionChip('Max Brightness', 'brightness_high'),
                      _buildActionChip('Performance Mode', 'speed'),
                      _buildActionChip('Clean RAM', 'memory'),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Add routine creation logic here
                          },
                          child: const Text('Create'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip(String label, String iconName) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.primaryCyan,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(label),
        ],
      ),
      selected: false,
      onSelected: (selected) {},
      backgroundColor: AppTheme.deepCharcoal,
      selectedColor: AppTheme.primaryCyan.withValues(alpha: 0.2),
      checkmarkColor: AppTheme.primaryCyan,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Routines Section
          Row(
            children: [
              Text(
                'Active Routines',
                style: AppTheme.darkTheme.textTheme.titleLarge,
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _showCreateRoutineDialog,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.primaryCyan,
                  size: 20,
                ),
                label: Text(
                  'Create',
                  style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.primaryCyan,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _activeRoutines.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final routine = _activeRoutines[index];
              return RoutineCardWidget(
                routine: routine,
                onToggle: () => _toggleRoutine(routine["id"] as int),
                onEdit: () {
                  // Show edit routine dialog
                },
              );
            },
          ),

          SizedBox(height: 4.h),

          // Scheduled Tasks Section
          Text(
            'Scheduled Tasks',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _scheduledTasks.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final task = _scheduledTasks[index];
              return ScheduledTaskWidget(
                task: task,
                onToggle: () => _toggleTask(task["id"] as int),
                onEdit: () {
                  // Show edit task dialog
                },
              );
            },
          ),

          SizedBox(height: 4.h),

          // Voice Commands Help
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: AppTheme.glassmorphismDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'mic',
                      color: AppTheme.primaryCyan,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Voice Commands',
                      style: AppTheme.darkTheme.textTheme.titleMedium,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'Try saying:',
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 1.h),
                ..._activeRoutines.where((r) => r["isActive"] as bool).map(
                      (routine) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: Text(
                          '• "${routine["voice_trigger"]}"',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryCyan,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),

          SizedBox(height: 10.h), // Space for FAB
        ],
      ),
    );
  }
}
