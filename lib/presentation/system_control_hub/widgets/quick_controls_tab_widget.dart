import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './brightness_control_widget.dart';
import './performance_control_widget.dart';
import './system_control_card_widget.dart';
import './volume_control_widget.dart';

class QuickControlsTabWidget extends StatelessWidget {
  final Map<String, dynamic> systemStatus;
  final Function(String, dynamic) onSystemUpdate;

  const QuickControlsTabWidget({
    Key? key,
    required this.systemStatus,
    required this.onSystemUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // System Status Header
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
                      iconName: 'dashboard',
                      color: AppTheme.primaryCyan,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'System Status',
                      style: AppTheme.darkTheme.textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Text(
                      'Last updated: ${_formatTime(systemStatus["last_updated"] as DateTime)}',
                      style: AppTheme.darkTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatusIndicator(
                        'Battery',
                        '${systemStatus["battery_level"]}%',
                        systemStatus["battery_level"] as int > 20 
                            ? AppTheme.successGreen 
                            : AppTheme.errorRed,
                        'battery_full',
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: _buildStatusIndicator(
                        'RAM',
                        '${(systemStatus["ram_usage"] as double).toStringAsFixed(1)}%',
                        systemStatus["ram_usage"] as double < 80 
                            ? AppTheme.successGreen 
                            : AppTheme.warningAmber,
                        'memory',
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: _buildStatusIndicator(
                        'Storage',
                        '${(systemStatus["storage_used"] as double).toStringAsFixed(1)}%',
                        systemStatus["storage_used"] as double < 80 
                            ? AppTheme.successGreen 
                            : AppTheme.warningAmber,
                        'storage',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 3.h),
          
          // Quick Controls Section
          Text(
            'Quick Controls',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),
          
          // Brightness and Volume Controls
          BrightnessControlWidget(
            brightness: systemStatus["brightness"] as double,
            onBrightnessChanged: (value) => onSystemUpdate('brightness', value),
          ),
          
          SizedBox(height: 2.h),
          
          VolumeControlWidget(
            volume: systemStatus["volume"] as double,
            onVolumeChanged: (value) => onSystemUpdate('volume', value),
          ),
          
          SizedBox(height: 3.h),
          
          // System Toggle Controls Grid
          Text(
            'System Toggles',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.2,
            children: [
              SystemControlCardWidget(
                title: 'Wi-Fi',
                subtitle: systemStatus["wifi_enabled"] as bool ? 'Connected' : 'Disconnected',
                iconName: 'wifi',
                isEnabled: systemStatus["wifi_enabled"] as bool,
                voiceCommand: 'wifi ${systemStatus["wifi_enabled"] as bool ? "band" : "on"} karo',
                onTap: () => onSystemUpdate('wifi_enabled', !(systemStatus["wifi_enabled"] as bool)),
              ),
              
              SystemControlCardWidget(
                title: 'Bluetooth',
                subtitle: systemStatus["bluetooth_enabled"] as bool ? 'Connected' : 'Disconnected',
                iconName: 'bluetooth',
                isEnabled: systemStatus["bluetooth_enabled"] as bool,
                voiceCommand: 'bluetooth ${systemStatus["bluetooth_enabled"] as bool ? "band" : "on"} karo',
                onTap: () => onSystemUpdate('bluetooth_enabled', !(systemStatus["bluetooth_enabled"] as bool)),
              ),
              
              SystemControlCardWidget(
                title: 'Do Not Disturb',
                subtitle: systemStatus["dnd_enabled"] as bool ? 'Active' : 'Inactive',
                iconName: 'do_not_disturb',
                isEnabled: systemStatus["dnd_enabled"] as bool,
                voiceCommand: 'dnd ${systemStatus["dnd_enabled"] as bool ? "band" : "on"} karo',
                onTap: () => onSystemUpdate('dnd_enabled', !(systemStatus["dnd_enabled"] as bool)),
              ),
              
              SystemControlCardWidget(
                title: 'Screen Lock',
                subtitle: systemStatus["screen_locked"] as bool ? 'Locked' : 'Unlocked',
                iconName: 'lock',
                isEnabled: systemStatus["screen_locked"] as bool,
                voiceCommand: 'phone ${systemStatus["screen_locked"] as bool ? "unlock" : "lock"} karo',
                onTap: () => onSystemUpdate('screen_locked', !(systemStatus["screen_locked"] as bool)),
              ),
            ],
          ),
          
          SizedBox(height: 3.h),
          
          // Performance Controls
          Text(
            'Performance',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),
          
          PerformanceControlWidget(
            ramUsage: systemStatus["ram_usage"] as double,
            storageUsed: systemStatus["storage_used"] as double,
            onRamClean: () {
              onSystemUpdate('ram_usage', ((systemStatus["ram_usage"] as double) * 0.7).clamp(0, 100));
            },
            onStorageClean: () {
              onSystemUpdate('storage_used', ((systemStatus["storage_used"] as double) * 0.9).clamp(0, 100));
            },
          ),
          
          SizedBox(height: 10.h), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String label, String value, Color color, String iconName) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 20,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}