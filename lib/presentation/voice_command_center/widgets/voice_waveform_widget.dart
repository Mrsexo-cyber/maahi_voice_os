import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceWaveformWidget extends StatefulWidget {
  final bool isListening;
  final VoidCallback onTap;

  const VoiceWaveformWidget({
    Key? key,
    required this.isListening,
    required this.onTap,
  }) : super(key: key);

  @override
  State<VoiceWaveformWidget> createState() => _VoiceWaveformWidgetState();
}

class _VoiceWaveformWidgetState extends State<VoiceWaveformWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(VoiceWaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      if (widget.isListening) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: 20.h,
        decoration: BoxDecoration(
          color: AppTheme.deepCharcoal,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isListening
                ? AppTheme.primaryCyan
                : AppTheme.borderColor,
            width: 2,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background pattern
            CustomPaint(
              size: Size(double.infinity, 20.h),
              painter: WaveformBackgroundPainter(),
            ),
            // Animated waveform
            if (widget.isListening)
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(double.infinity, 20.h),
                    painter: AnimatedWaveformPainter(_animation.value),
                  );
                },
              ),
            // Center microphone button
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: widget.isListening
                    ? AppTheme.primaryCyan
                    : AppTheme.elevatedSurface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.isListening
                        ? AppTheme.primaryCyan.withValues(alpha: 0.3)
                        : AppTheme.shadowColor,
                    blurRadius: widget.isListening ? 20 : 8,
                    spreadRadius: widget.isListening ? 4 : 0,
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: widget.isListening ? 'mic' : 'mic_none',
                  color: widget.isListening
                      ? AppTheme.trueDarkBackground
                      : AppTheme.primaryCyan,
                  size: 32,
                ),
              ),
            ),
            // Status text
            Positioned(
              bottom: 2.h,
              child: Text(
                widget.isListening ? "Listening..." : "Tap to speak",
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: widget.isListening
                      ? AppTheme.primaryCyan
                      : AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveformBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.borderColor.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2;
    final barWidth = 3.0;
    final barSpacing = 6.0;
    final totalBars = (size.width / (barWidth + barSpacing)).floor();

    for (int i = 0; i < totalBars; i++) {
      final x = i * (barWidth + barSpacing) + barWidth / 2;
      final height = 20.0; // Static height for background

      canvas.drawLine(
        Offset(x, centerY - height / 2),
        Offset(x, centerY + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AnimatedWaveformPainter extends CustomPainter {
  final double animationValue;

  AnimatedWaveformPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final barWidth = 3.0;
    final barSpacing = 6.0;
    final totalBars = (size.width / (barWidth + barSpacing)).floor();

    for (int i = 0; i < totalBars; i++) {
      final x = i * (barWidth + barSpacing) + barWidth / 2;

      // Create wave effect
      final waveOffset = (i / totalBars) * 2 * 3.14159;
      final waveHeight = 40 +
          30 *
              (0.5 +
                  0.5 *
                      (animationValue * 2 - 1).abs() *
                      (1 + 0.5 * (i % 3 - 1)));

      // Color gradient based on position
      final colorIndex =
          (i / totalBars * AppTheme.waveformColors.length).floor();
      paint.color = AppTheme.waveformColors[
          colorIndex.clamp(0, AppTheme.waveformColors.length - 1)];

      canvas.drawLine(
        Offset(x, centerY - waveHeight / 2),
        Offset(x, centerY + waveHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
