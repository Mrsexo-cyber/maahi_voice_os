import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SystemMetricsWidget extends StatelessWidget {
  final Map<String, dynamic> systemStatus;
  final Function(String) onMetricTap;

  const SystemMetricsWidget({
    Key? key,
    required this.systemStatus,
    required this.onMetricTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 3.w,
      mainAxisSpacing: 2.h,
      childAspectRatio: 1.3,
      children: [
        _buildMetricCard(
          'CPU Usage',
          '${systemStatus["cpu_usage"]?.toStringAsFixed(1) ?? "0"}%',
          'memory',
          AppTheme.primaryCyan,
          'cpu',
          systemStatus["cpu_usage"] as double? ?? 0,
        ),
        _buildMetricCard(
          'RAM Usage',
          '${systemStatus["ram_usage"]?.toStringAsFixed(1) ?? "0"}%',
          'memory',
          AppTheme.warningAmber,
          'memory',
          systemStatus["ram_usage"] as double? ?? 0,
        ),
        _buildMetricCard(
          'Battery',
          '${systemStatus["battery_level"] ?? 0}%',
          'battery_full',
          AppTheme.successGreen,
          'battery',
          (systemStatus["battery_level"] as int? ?? 0).toDouble(),
        ),
        _buildMetricCard(
          'Storage',
          '${systemStatus["storage_used"]?.toStringAsFixed(1) ?? "0"}%',
          'storage',
          AppTheme.tealAccent,
          'storage',
          systemStatus["storage_used"] as double? ?? 0,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String iconName,
    Color color,
    String metricKey,
    double percentage,
  ) {
    return GestureDetector(
      onTap: () => onMetricTap(metricKey),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.deepCharcoal,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and status
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: color,
                    size: 20,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.w),
                  decoration: BoxDecoration(
                    color: _getStatusColor(percentage).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getStatusText(percentage),
                    style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(percentage),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Title
            Text(
              title,
              style: AppTheme.darkTheme.textTheme.titleSmall,
            ),

            SizedBox(height: 0.5.h),

            // Value
            Text(
              value,
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 1.h),

            // Progress bar
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppTheme.borderColor,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),

            SizedBox(height: 1.h),

            // Additional info
            Text(
              _getAdditionalInfo(metricKey, percentage),
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(double percentage) {
    if (percentage < 50) return AppTheme.successGreen;
    if (percentage < 80) return AppTheme.warningAmber;
    return AppTheme.errorRed;
  }

  String _getStatusText(double percentage) {
    if (percentage < 50) return 'Good';
    if (percentage < 80) return 'Warning';
    return 'Critical';
  }

  String _getAdditionalInfo(String metricKey, double percentage) {
    switch (metricKey) {
      case 'cpu':
        return 'Avg: 28.5%';
      case 'memory':
        final usedGB = (percentage / 100 * 8).toStringAsFixed(1);
        return '${usedGB}GB used';
      case 'battery':
        return 'Charging';
      case 'storage':
        final usedGB = (percentage / 100 * 128).toStringAsFixed(0);
        return '${usedGB}GB used';
      default:
        return 'Tap for details';
    }
  }
}
