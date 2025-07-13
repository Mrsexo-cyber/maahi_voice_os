import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final int completedSteps;

  const ProgressIndicatorWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.completedSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          _buildProgressBar(),
          SizedBox(height: 2.h),
          _buildProgressDots(),
          SizedBox(height: 1.h),
          _buildProgressText(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final double progress = currentStep / totalSteps;

    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: AppTheme.borderColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.borderColor,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryCyan,
                    AppTheme.tealAccent,
                  ],
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final bool isCompleted = index < completedSteps;
        final bool isCurrent = index == currentStep - 1;
        final bool isPending = index >= currentStep;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          child: _buildProgressDot(
            isCompleted: isCompleted,
            isCurrent: isCurrent,
            isPending: isPending,
            stepNumber: index + 1,
          ),
        );
      }),
    );
  }

  Widget _buildProgressDot({
    required bool isCompleted,
    required bool isCurrent,
    required bool isPending,
    required int stepNumber,
  }) {
    Color dotColor;
    Color borderColor;
    Widget? child;

    if (isCompleted) {
      dotColor = AppTheme.successGreen;
      borderColor = AppTheme.successGreen;
      child = CustomIconWidget(
        iconName: 'check',
        color: AppTheme.textPrimary,
        size: 12,
      );
    } else if (isCurrent) {
      dotColor = AppTheme.primaryCyan;
      borderColor = AppTheme.primaryCyan;
      child = Text(
        stepNumber.toString(),
        style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
          color: AppTheme.trueDarkBackground,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      );
    } else {
      dotColor = Colors.transparent;
      borderColor = AppTheme.borderColor;
      child = Text(
        stepNumber.toString(),
        style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
          color: AppTheme.textSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      );
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: isCurrent ? 8.w : 6.w,
      height: isCurrent ? 8.w : 6.w,
      decoration: BoxDecoration(
        color: dotColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Center(child: child),
    );
  }

  Widget _buildProgressText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Step $currentStep of $totalSteps",
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "$completedSteps completed",
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: completedSteps > 0
                ? AppTheme.successGreen
                : AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
