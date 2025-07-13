import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SystemMetricsWidget extends StatelessWidget {
  final Map<String, dynamic> systemData;

  const SystemMetricsWidget({
    Key? key,
    required this.systemData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassmorphismDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'memory',
                color: AppTheme.primaryCyan,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'System Metrics',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryCyan,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // RAM Usage
          _buildMetricRow(
            'RAM Usage',
            '${(systemData["ramUsage"] as num).toStringAsFixed(1)}%',
            systemData["ramUsage"] as num,
            'memory',
            AppTheme.primaryCyan,
          ),

          SizedBox(height: 2.h),

          // Battery
          _buildMetricRow(
            'Battery',
            '${(systemData["batteryPercentage"] as num).toInt()}%',
            systemData["batteryPercentage"] as num,
            systemData["isCharging"] as bool
                ? 'battery_charging_full'
                : 'battery_std',
            _getBatteryColor(systemData["batteryPercentage"] as num),
          ),

          SizedBox(height: 2.h),

          // CPU Temperature
          _buildMetricRow(
            'CPU Temperature',
            '${(systemData["cpuTemperature"] as num).toStringAsFixed(1)}°C',
            (systemData["cpuTemperature"] as num) / 100,
            'thermostat',
            _getTemperatureColor(systemData["cpuTemperature"] as num),
          ),

          SizedBox(height: 2.h),

          // Network Status
          Row(
            children: [
              CustomIconWidget(
                iconName: 'wifi',
                color: AppTheme.successGreen,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Network',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      systemData["networkStatus"] as String,
                      style: AppTheme.dataTextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.successGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(
    String label,
    String value,
    num percentage,
    String icon,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        value,
                        style: AppTheme.dataTextStyle(
                          fontSize: 14.sp,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  LinearProgressIndicator(
                    value: (percentage / 100).clamp(0.0, 1.0),
                    backgroundColor: AppTheme.borderColor,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 0.8.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getBatteryColor(num percentage) {
    if (percentage > 50) return AppTheme.successGreen;
    if (percentage > 20) return AppTheme.warningAmber;
    return AppTheme.errorRed;
  }

  Color _getTemperatureColor(num temperature) {
    if (temperature > 70) return AppTheme.errorRed;
    if (temperature > 50) return AppTheme.warningAmber;
    return AppTheme.successGreen;
  }
}
