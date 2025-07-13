import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './performance_chart_widget.dart';
import './system_metrics_widget.dart';

class MonitoringTabWidget extends StatefulWidget {
  final Map<String, dynamic> systemStatus;

  const MonitoringTabWidget({
    Key? key,
    required this.systemStatus,
  }) : super(key: key);

  @override
  State<MonitoringTabWidget> createState() => _MonitoringTabWidgetState();
}

class _MonitoringTabWidgetState extends State<MonitoringTabWidget> {
  String _selectedMetric = 'cpu';

  // Mock historical data for charts
  final List<Map<String, dynamic>> _performanceHistory =
      List.generate(20, (index) {
    final now = DateTime.now();
    return {
      "timestamp": now.subtract(Duration(minutes: index * 5)),
      "cpu": 20 + (index * 3) % 60,
      "memory": 40 + (index * 2) % 40,
      "battery": 100 - (index * 2),
      "temperature": 35 + (index % 15),
      "network_speed": 10 + (index * 5) % 50,
    };
  }).reversed.toList();

  final List<Map<String, dynamic>> _systemAlerts = [
    {
      "id": 1,
      "type": "warning",
      "title": "High RAM Usage",
      "message": "RAM usage is above 80%. Consider closing some apps.",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
      "severity": "medium",
    },
    {
      "id": 2,
      "type": "info",
      "title": "Battery Optimization",
      "message": "Battery saver mode activated automatically.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "severity": "low",
    },
    {
      "id": 3,
      "type": "success",
      "title": "RAM Cleaned",
      "message": "Successfully freed 1.2 GB of RAM memory.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 4)),
      "severity": "low",
    },
  ];

  final Map<String, dynamic> _detailedMetrics = {
    "cpu": {
      "current": 34.7,
      "average": 28.5,
      "peak": 67.2,
      "unit": "%",
      "status": "normal",
    },
    "memory": {
      "current": 68.5,
      "average": 65.2,
      "peak": 89.1,
      "unit": "%",
      "status": "warning",
    },
    "battery": {
      "current": 82,
      "average": 75,
      "peak": 100,
      "unit": "%",
      "status": "good",
    },
    "temperature": {
      "current": 38,
      "average": 36,
      "peak": 45,
      "unit": "°C",
      "status": "normal",
    },
    "network": {
      "current": 25.4,
      "average": 18.7,
      "peak": 45.2,
      "unit": "Mbps",
      "status": "good",
    },
  };

  void _showDetailedView(String metric) {
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${metric.toUpperCase()} Detailed View',
                      style: AppTheme.darkTheme.textTheme.titleLarge,
                    ),
                    SizedBox(height: 3.h),
                    Expanded(
                      child: PerformanceChartWidget(
                        data: _performanceHistory,
                        metric: metric,
                        isDetailed: true,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    _buildDetailedStats(metric),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedStats(String metric) {
    final stats = _detailedMetrics[metric] as Map<String, dynamic>;
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.deepCharcoal,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Current',
              '${stats["current"]}${stats["unit"]}',
              AppTheme.primaryCyan,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              'Average',
              '${stats["average"]}${stats["unit"]}',
              AppTheme.textSecondary,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              'Peak',
              '${stats["peak"]}${stats["unit"]}',
              AppTheme.warningAmber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Color _getAlertColor(String severity) {
    switch (severity) {
      case 'high':
        return AppTheme.errorRed;
      case 'medium':
        return AppTheme.warningAmber;
      default:
        return AppTheme.successGreen;
    }
  }

  IconData _getAlertIcon(String type) {
    switch (type) {
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'success':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Real-time Metrics Overview
          Text(
            'Real-time Metrics',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),

          SystemMetricsWidget(
            systemStatus: widget.systemStatus,
            onMetricTap: _showDetailedView,
          ),

          SizedBox(height: 3.h),

          // Performance Chart Section
          Row(
            children: [
              Text(
                'Performance Chart',
                style: AppTheme.darkTheme.textTheme.titleLarge,
              ),
              const Spacer(),
              DropdownButton<String>(
                value: _selectedMetric,
                dropdownColor: AppTheme.elevatedSurface,
                style: AppTheme.darkTheme.textTheme.bodyMedium,
                underline: Container(),
                items: const [
                  DropdownMenuItem(value: 'cpu', child: Text('CPU')),
                  DropdownMenuItem(value: 'memory', child: Text('Memory')),
                  DropdownMenuItem(value: 'battery', child: Text('Battery')),
                  DropdownMenuItem(
                      value: 'temperature', child: Text('Temperature')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedMetric = value;
                    });
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 2.h),

          Container(
            height: 30.h,
            padding: EdgeInsets.all(3.w),
            decoration: AppTheme.glassmorphismDecoration,
            child: PerformanceChartWidget(
              data: _performanceHistory,
              metric: _selectedMetric,
            ),
          ),

          SizedBox(height: 3.h),

          // System Alerts Section
          Row(
            children: [
              Text(
                'System Alerts',
                style: AppTheme.darkTheme.textTheme.titleLarge,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Clear all alerts
                  setState(() {
                    _systemAlerts.clear();
                  });
                },
                child: Text(
                  'Clear All',
                  style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          _systemAlerts.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.deepCharcoal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.successGreen,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'All systems running smoothly',
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.successGreen,
                        ),
                      ),
                      Text(
                        'No alerts or warnings at this time',
                        style: AppTheme.darkTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _systemAlerts.length,
                  separatorBuilder: (context, index) => SizedBox(height: 1.h),
                  itemBuilder: (context, index) {
                    final alert = _systemAlerts[index];
                    final alertColor =
                        _getAlertColor(alert["severity"] as String);

                    return Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.deepCharcoal,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: alertColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: alertColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getAlertIcon(alert["type"] as String),
                              color: alertColor,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  alert["title"] as String,
                                  style: AppTheme.darkTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    color: alertColor,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  alert["message"] as String,
                                  style: AppTheme.darkTheme.textTheme.bodySmall,
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  _formatTimestamp(
                                      alert["timestamp"] as DateTime),
                                  style: AppTheme.darkTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _systemAlerts.removeAt(index);
                              });
                            },
                            icon: CustomIconWidget(
                              iconName: 'close',
                              color: AppTheme.textSecondary,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

          SizedBox(height: 4.h),

          // Voice Commands for Monitoring
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
                ...[
                  '"system status dikhao"',
                  '"ram usage check karo"',
                  '"battery level batao"',
                  '"performance monitor karo"',
                  '"alerts clear karo"',
                ].map((command) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.5.h),
                      child: Text(
                        '• $command',
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryCyan,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )),
              ],
            ),
          ),

          SizedBox(height: 10.h), // Space for FAB
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
