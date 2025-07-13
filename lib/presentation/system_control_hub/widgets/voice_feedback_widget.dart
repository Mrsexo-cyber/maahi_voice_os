import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

import '../../../core/app_export.dart';

class VoiceFeedbackWidget extends StatefulWidget {
  final String command;
  final bool isActive;

  const VoiceFeedbackWidget({
    Key? key,
    required this.command,
    required this.isActive,
  }) : super(key: key);

  @override
  State<VoiceFeedbackWidget> createState() => _VoiceFeedbackWidgetState();
}

class _VoiceFeedbackWidgetState extends State<VoiceFeedbackWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.linear,
    ));

    if (widget.isActive) {
      _pulseController.repeat(reverse: true);
      _waveController.repeat();
    }
  }

  @override
  void didUpdateWidget(VoiceFeedbackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _pulseController.repeat(reverse: true);
        _waveController.repeat();
      } else {
        _pulseController.stop();
        _waveController.stop();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: widget.isActive ? 12.h : 0,
      child: widget.isActive
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryCyan.withValues(alpha: 0.2),
                    AppTheme.tealAccent.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryCyan.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  // Animated microphone icon
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryCyan.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CustomIconWidget(
                            iconName: 'mic',
                            color: AppTheme.primaryCyan,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(width: 3.w),

                  // Voice waveform animation
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Listening...',
                          style: AppTheme.darkTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.primaryCyan,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '"${widget.command}"',
                          style:
                              AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                            color: AppTheme.textPrimary,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        // Animated waveform bars
                        AnimatedBuilder(
                          animation: _waveAnimation,
                          builder: (context, child) {
                            return Row(
                              children: List.generate(8, (index) {
                                final height = (0.5 +
                                        (0.5 *
                                            (1 +
                                                    math.sin(index * 0.3 +
                                                            _waveAnimation
                                                                    .value *
                                                                2 *
                                                                3.14159))
                                                .abs()))
                                    .h;
                                return Container(
                                  width: 0.8.w,
                                  height: height,
                                  margin: EdgeInsets.only(right: 0.5.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme.waveformColors[
                                        index % AppTheme.waveformColors.length],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Status indicator
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 2.w,
                          height: 2.w,
                          decoration: const BoxDecoration(
                            color: AppTheme.successGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Active',
                          style:
                              AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.successGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}