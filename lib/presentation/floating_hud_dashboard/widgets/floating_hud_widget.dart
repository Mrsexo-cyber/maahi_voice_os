import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import './voice_waveform_widget.dart';

class FloatingHudWidget extends StatelessWidget {
  final Map<String, dynamic> systemData;
  final bool isListening;
  final AnimationController waveformController;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Function(DragUpdateDetails) onPanUpdate;

  const FloatingHudWidget({
    Key? key,
    required this.systemData,
    required this.isListening,
    required this.waveformController,
    required this.onTap,
    required this.onLongPress,
    required this.onPanUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      onPanUpdate: onPanUpdate,
      child: Container(
        width: 20.w,
        height: 20.w,
        decoration: BoxDecoration(
          color: AppTheme.elevatedSurface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(10.w),
          border: Border.all(
            color: isListening ? AppTheme.primaryCyan : AppTheme.borderColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isListening
                  ? AppTheme.primaryCyan.withValues(alpha: 0.3)
                  : AppTheme.shadowColor,
              blurRadius: isListening ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Avatar background
            Center(
              child: Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryCyan.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Center(
                  child: Text(
                    'M',
                    style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.primaryCyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Voice waveform overlay
            if (isListening)
              Positioned.fill(
                child: VoiceWaveformWidget(
                  controller: waveformController,
                  isCompact: true,
                ),
              ),

            // System metrics overlay
            Positioned(
              bottom: 1.w,
              right: 1.w,
              child: Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: AppTheme.trueDarkBackground.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(systemData["batteryPercentage"] as num).toInt()}%',
                      style: AppTheme.dataTextStyle(
                        fontSize: 8.sp,
                        color: AppTheme.primaryCyan,
                      ),
                    ),
                    Text(
                      '${(systemData["ramUsage"] as num).toInt()}%',
                      style: AppTheme.dataTextStyle(
                        fontSize: 6.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
