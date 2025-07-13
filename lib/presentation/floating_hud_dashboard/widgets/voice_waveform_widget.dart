import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class VoiceWaveformWidget extends StatefulWidget {
  final AnimationController controller;
  final bool isCompact;

  const VoiceWaveformWidget({
    Key? key,
    required this.controller,
    this.isCompact = false,
  }) : super(key: key);

  @override
  State<VoiceWaveformWidget> createState() => _VoiceWaveformWidgetState();
}

class _VoiceWaveformWidgetState extends State<VoiceWaveformWidget>
    with SingleTickerProviderStateMixin {
  late List<Animation<double>> _waveAnimations;

  @override
  void initState() {
    super.initState();
    _initializeWaveAnimations();
  }

  void _initializeWaveAnimations() {
    final int barCount = widget.isCompact ? 8 : 20;
    _waveAnimations = List.generate(barCount, (index) {
      return Tween<double>(
        begin: 0.2,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: widget.controller,
          curve: Interval(
            (index / barCount) * 0.5,
            ((index / barCount) * 0.5) + 0.5,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return Container(
          width: widget.isCompact ? 16.w : 80.w,
          height: widget.isCompact ? 6.w : 6.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _waveAnimations.asMap().entries.map((entry) {
              final index = entry.key;
              final animation = entry.value;

              return Container(
                width: widget.isCompact ? 0.5.w : 1.w,
                height: (widget.isCompact ? 4.w : 4.h) * animation.value,
                decoration: BoxDecoration(
                  color: _getBarColor(index),
                  borderRadius:
                      BorderRadius.circular(widget.isCompact ? 0.25.w : 0.5.w),
                  boxShadow: [
                    BoxShadow(
                      color: _getBarColor(index).withValues(alpha: 0.3),
                      blurRadius: 2,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Color _getBarColor(int index) {
    final colors = AppTheme.waveformColors;
    return colors[index % colors.length];
  }
}
