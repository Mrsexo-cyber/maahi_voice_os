import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final List<String> features;
  final Widget? customContent;

  const OnboardingPageWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.features,
    this.customContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Hero Image
          Container(
            width: 70.w,
            height: 25.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowColor,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomImageWidget(
                imageUrl: imageUrl,
                width: 70.w,
                height: 25.h,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Title
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.primaryCyan,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          // Subtitle
          Text(
            subtitle,
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Description
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              description,
              style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textPrimary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 3.h),

          // Features List
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.elevatedSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.borderColor.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Features:',
                  style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.primaryCyan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                ...features
                    .map((feature) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.5.h),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'check_circle',
                                color: AppTheme.tealAccent,
                                size: 20,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: AppTheme.darkTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),

          // Custom Content
          if (customContent != null) ...[
            SizedBox(height: 2.h),
            customContent!,
          ],

          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
