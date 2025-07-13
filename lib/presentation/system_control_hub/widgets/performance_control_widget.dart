import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PerformanceControlWidget extends StatefulWidget {
  final double ramUsage;
  final double storageUsed;
  final VoidCallback onRamClean;
  final VoidCallback onStorageClean;

  const PerformanceControlWidget({
    Key? key,
    required this.ramUsage,
    required this.storageUsed,
    required this.onRamClean,
    required this.onStorageClean,
  }) : super(key: key);

  @override
  State<PerformanceControlWidget> createState() =>
      _PerformanceControlWidgetState();
}

class _PerformanceControlWidgetState extends State<PerformanceControlWidget>
    with TickerProviderStateMixin {
  late AnimationController _ramCleanController;
  late AnimationController _storageCleanController;
  late Animation<double> _ramCleanAnimation;
  late Animation<double> _storageCleanAnimation;

  bool _isRamCleaning = false;
  bool _isStorageCleaning = false;

  @override
  void initState() {
    super.initState();
    _ramCleanController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _storageCleanController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _ramCleanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _ramCleanController,
      curve: Curves.easeInOut,
    ));

    _storageCleanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _storageCleanController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _ramCleanController.dispose();
    _storageCleanController.dispose();
    super.dispose();
  }

  Future<void> _performRamClean() async {
    setState(() {
      _isRamCleaning = true;
    });

    _ramCleanController.forward();

    await Future.delayed(const Duration(seconds: 2));

    widget.onRamClean();

    setState(() {
      _isRamCleaning = false;
    });

    _ramCleanController.reset();
  }

  Future<void> _performStorageClean() async {
    setState(() {
      _isStorageCleaning = true;
    });

    _storageCleanController.forward();

    await Future.delayed(const Duration(seconds: 3));

    widget.onStorageClean();

    setState(() {
      _isStorageCleaning = false;
    });

    _storageCleanController.reset();
  }

  Color _getUsageColor(double usage) {
    if (usage < 50) return AppTheme.successGreen;
    if (usage < 80) return AppTheme.warningAmber;
    return AppTheme.errorRed;
  }

  String _getUsageStatus(double usage) {
    if (usage < 50) return 'Good';
    if (usage < 80) return 'Warning';
    return 'Critical';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassmorphismDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'speed',
                color: AppTheme.primaryCyan,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Performance Optimization',
                style: AppTheme.darkTheme.textTheme.titleMedium,
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // RAM Usage Section
          _buildUsageSection(
            title: 'RAM Memory',
            usage: widget.ramUsage,
            icon: 'memory',
            isProcessing: _isRamCleaning,
            animation: _ramCleanAnimation,
            onClean: _performRamClean,
            voiceCommand: 'ram clean karo',
            details: _getRamDetails(),
          ),

          SizedBox(height: 3.h),

          // Storage Usage Section
          _buildUsageSection(
            title: 'Storage Space',
            usage: widget.storageUsed,
            icon: 'storage',
            isProcessing: _isStorageCleaning,
            animation: _storageCleanAnimation,
            onClean: _performStorageClean,
            voiceCommand: 'storage clean karo',
            details: _getStorageDetails(),
          ),

          SizedBox(height: 3.h),

          // Quick Actions Row
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Boost Performance',
                  'flash_on',
                  () {
                    _performRamClean();
                    Future.delayed(const Duration(milliseconds: 500), () {
                      _performStorageClean();
                    });
                  },
                  AppTheme.primaryCyan,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickActionButton(
                  'Battery Saver',
                  'battery_saver',
                  () {
                    // Implement battery saver logic
                  },
                  AppTheme.successGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsageSection({
    required String title,
    required double usage,
    required String icon,
    required bool isProcessing,
    required Animation<double> animation,
    required VoidCallback onClean,
    required String voiceCommand,
    required Map<String, String> details,
  }) {
    final usageColor = _getUsageColor(usage);
    final usageStatus = _getUsageStatus(usage);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.deepCharcoal,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: usageColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: usageColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: icon,
                  color: usageColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.darkTheme.textTheme.titleSmall,
                    ),
                    Text(
                      '$usageStatus (${usage.toStringAsFixed(1)}%)',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: usageColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Clean button
              GestureDetector(
                onTap: isProcessing ? null : onClean,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.w),
                  decoration: BoxDecoration(
                    color: isProcessing
                        ? AppTheme.borderColor
                        : usageColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isProcessing ? AppTheme.borderColor : usageColor,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isProcessing)
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(usageColor),
                          ),
                        )
                      else
                        CustomIconWidget(
                          iconName: 'cleaning_services',
                          color: usageColor,
                          size: 16,
                        ),
                      SizedBox(width: 1.w),
                      Text(
                        isProcessing ? 'Cleaning...' : 'Clean',
                        style:
                            AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                          color: isProcessing
                              ? AppTheme.textSecondary
                              : usageColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Usage progress bar with animation
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final displayUsage =
                  isProcessing ? usage * (1 - animation.value * 0.7) : usage;

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: displayUsage / 100,
                          backgroundColor: AppTheme.borderColor,
                          valueColor: AlwaysStoppedAnimation<Color>(usageColor),
                          minHeight: 8,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${displayUsage.toStringAsFixed(1)}%',
                        style: AppTheme.dataTextStyle(
                          fontSize: 12,
                          color: usageColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (isProcessing)
                    Padding(
                      padding: EdgeInsets.only(top: 1.h),
                      child: Text(
                        'Optimizing... ${(animation.value * 100).toInt()}%',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: usageColor,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          SizedBox(height: 2.h),

          // Details and voice command
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: details.entries
                      .map((entry) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.25.h),
                            child: Row(
                              children: [
                                Text(
                                  '${entry.key}: ',
                                  style: AppTheme.darkTheme.textTheme.bodySmall,
                                ),
                                Text(
                                  entry.value,
                                  style: AppTheme.darkTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.primaryCyan,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color: AppTheme.elevatedSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'mic',
                      color: AppTheme.primaryCyan,
                      size: 12,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      voiceCommand,
                      style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.primaryCyan,
                        fontStyle: FontStyle.italic,
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

  Widget _buildQuickActionButton(
    String label,
    String iconName,
    VoidCallback onTap,
    Color color,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> _getRamDetails() {
    final usedGB = (widget.ramUsage / 100 * 8).toStringAsFixed(1);
    final freeGB = (8 - (widget.ramUsage / 100 * 8)).toStringAsFixed(1);

    return {
      'Used': '${usedGB}GB',
      'Free': '${freeGB}GB',
      'Total': '8GB',
    };
  }

  Map<String, String> _getStorageDetails() {
    final usedGB = (widget.storageUsed / 100 * 128).toStringAsFixed(1);
    final freeGB = (128 - (widget.storageUsed / 100 * 128)).toStringAsFixed(1);

    return {
      'Used': '${usedGB}GB',
      'Free': '${freeGB}GB',
      'Total': '128GB',
    };
  }
}
