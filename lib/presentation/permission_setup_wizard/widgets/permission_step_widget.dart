import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PermissionStepWidget extends StatelessWidget {
  final Map<String, dynamic> permissionData;
  final VoidCallback onGrantPermission;
  final VoidCallback onSkip;

  const PermissionStepWidget({
    Key? key,
    required this.permissionData,
    required this.onGrantPermission,
    required this.onSkip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isGranted = permissionData["isGranted"] ?? false;
    final bool isRequired = permissionData["isRequired"] ?? true;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          _buildPermissionIcon(isGranted),
          SizedBox(height: 4.h),
          _buildPermissionTitle(),
          SizedBox(height: 2.h),
          _buildPermissionDescription(),
          SizedBox(height: 3.h),
          _buildBenefitCard(),
          SizedBox(height: 2.h),
          _buildConcernsCard(),
          SizedBox(height: 4.h),
          _buildActionButtons(isGranted, isRequired),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildPermissionIcon(bool isGranted) {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        color: isGranted
            ? AppTheme.successGreen.withValues(alpha: 0.2)
            : AppTheme.primaryCyan.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isGranted ? AppTheme.successGreen : AppTheme.primaryCyan,
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomIconWidget(
            iconName: permissionData["icon"] ?? "help",
            color: isGranted ? AppTheme.successGreen : AppTheme.primaryCyan,
            size: 40,
          ),
          if (isGranted)
            Positioned(
              bottom: 2.w,
              right: 2.w,
              child: Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'check',
                  color: AppTheme.textPrimary,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPermissionTitle() {
    return Column(
      children: [
        Text(
          permissionData["title"] ?? "Permission",
          style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        if (permissionData["isRequired"] == true)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.errorRed.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: AppTheme.errorRed.withValues(alpha: 0.3)),
            ),
            child: Text(
              "Required",
              style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.errorRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPermissionDescription() {
    return Text(
      permissionData["description"] ?? "Permission description",
      style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
        color: AppTheme.textSecondary,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildBenefitCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryCyan.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryCyan.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'star',
                color: AppTheme.primaryCyan,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                "What you can do:",
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryCyan,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            permissionData["benefit"] ?? "Enhanced functionality",
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConcernsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.tealAccent,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                "Privacy & Security:",
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.tealAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            permissionData["concerns"] ?? "Your data is secure",
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isGranted, bool isRequired) {
    if (isGranted) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.successGreen.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: AppTheme.successGreen.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.successGreen,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              "Permission Granted",
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.successGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onGrantPermission,
            style: AppTheme.darkTheme.elevatedButtonTheme.style?.copyWith(
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(vertical: 4.w),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  color: AppTheme.trueDarkBackground,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Text(
                  "Grant Permission",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isRequired) ...[
          SizedBox(height: 3.w),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onSkip,
              style: AppTheme.darkTheme.textButtonTheme.style?.copyWith(
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(vertical: 3.w),
                ),
              ),
              child: Text(
                "Skip for now",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
