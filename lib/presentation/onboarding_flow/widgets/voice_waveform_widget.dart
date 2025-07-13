import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class VoiceWaveformWidget extends StatefulWidget {
  final AnimationController controller;
  final bool isActive;

  const VoiceWaveformWidget({
    Key? key,
    required this.controller,
    required this.isActive,
  }) : super(key: key);

  @override
  State<VoiceWaveformWidget> createState() => _VoiceWaveformWidgetState();
}

class _VoiceWaveformWidgetState extends State<VoiceWaveformWidget> {
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animations = List.generate(5, (index) {
      return Tween<double>(
        begin: 0.3,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: widget.controller,
          curve: Interval(
            index * 0.1,
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isActive
              ? AppTheme.primaryCyan.withValues(alpha: 0.5)
              : AppTheme.borderColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Container(
                  width: 1.w,
                  height:
                      widget.isActive ? _animations[index].value * 4.h : 1.h,
                  decoration: BoxDecoration(
                    color: widget.isActive
                        ? AppTheme.primaryCyan
                        : AppTheme.textSecondary.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
