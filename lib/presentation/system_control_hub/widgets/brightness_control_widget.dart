import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BrightnessControlWidget extends StatefulWidget {
  final double brightness;
  final ValueChanged<double> onBrightnessChanged;

  const BrightnessControlWidget({
    Key? key,
    required this.brightness,
    required this.onBrightnessChanged,
  }) : super(key: key);

  @override
  State<BrightnessControlWidget> createState() =>
      _BrightnessControlWidgetState();
}

class _BrightnessControlWidgetState extends State<BrightnessControlWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  String get _brightnessLevel {
    if (widget.brightness < 25) return 'Low';
    if (widget.brightness < 50) return 'Medium';
    if (widget.brightness < 75) return 'High';
    return 'Maximum';
  }

  Color get _brightnessColor {
    if (widget.brightness < 25) return AppTheme.warningAmber;
    if (widget.brightness < 75) return AppTheme.primaryCyan;
    return AppTheme.successGreen;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassmorphismDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
              AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _brightnessColor.withValues(
                          alpha: 0.1 * _glowAnimation.value),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _brightnessColor.withValues(
                              alpha: 0.3 * _glowAnimation.value),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CustomIconWidget(
                      iconName: 'brightness_6',
                      color: _brightnessColor,
                      size: 24,
                    ),
                  );
                },
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Screen Brightness',
                      style: AppTheme.darkTheme.textTheme.titleMedium,
                    ),
                    Text(
                      '$_brightnessLevel (${widget.brightness.toInt()}%)',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: _brightnessColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Voice command hint
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color: AppTheme.deepCharcoal,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'mic',
                      color: AppTheme.primaryCyan,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'brightness badhao/kam karo',
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

          SizedBox(height: 3.h),

          // Brightness slider with visual feedback
          Row(
            children: [
              // Minimum brightness icon
              CustomIconWidget(
                iconName: 'brightness_low',
                color: AppTheme.textSecondary,
                size: 20,
              ),
              SizedBox(width: 2.w),

              // Custom slider
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6.0,
                    thumbShape: CustomSliderThumb(
                      thumbRadius: 12.0,
                      color: _brightnessColor,
                      isDragging: _isDragging,
                    ),
                    overlayShape: RoundSliderOverlayShape(
                      overlayRadius: _isDragging ? 20.0 : 16.0,
                    ),
                    overlayColor: _brightnessColor.withValues(alpha: 0.2),
                    activeTrackColor: _brightnessColor,
                    inactiveTrackColor: AppTheme.borderColor,
                    thumbColor: _brightnessColor,
                  ),
                  child: Slider(
                    value: widget.brightness,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    onChangeStart: (value) {
                      setState(() {
                        _isDragging = true;
                      });
                    },
                    onChangeEnd: (value) {
                      setState(() {
                        _isDragging = false;
                      });
                    },
                    onChanged: widget.onBrightnessChanged,
                  ),
                ),
              ),

              SizedBox(width: 2.w),
              // Maximum brightness icon
              CustomIconWidget(
                iconName: 'brightness_high',
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Quick brightness presets
          Row(
            children: [
              Text(
                'Quick Presets:',
                style: AppTheme.darkTheme.textTheme.bodySmall,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Row(
                  children: [
                    _buildPresetButton('25%', 25),
                    SizedBox(width: 2.w),
                    _buildPresetButton('50%', 50),
                    SizedBox(width: 2.w),
                    _buildPresetButton('75%', 75),
                    SizedBox(width: 2.w),
                    _buildPresetButton('100%', 100),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButton(String label, double value) {
    final isSelected = (widget.brightness - value).abs() < 5;

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onBrightnessChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            color: isSelected
                ? _brightnessColor.withValues(alpha: 0.2)
                : AppTheme.deepCharcoal,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? _brightnessColor : AppTheme.borderColor,
            ),
          ),
          child: Text(
            label,
            style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
              color: isSelected ? _brightnessColor : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class CustomSliderThumb extends SliderComponentShape {
  final double thumbRadius;
  final Color color;
  final bool isDragging;

  const CustomSliderThumb({
    required this.thumbRadius,
    required this.color,
    required this.isDragging,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Draw outer glow when dragging
    if (isDragging) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, thumbRadius + 4, glowPaint);
    }

    // Draw main thumb
    final thumbPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius, thumbPaint);

    // Draw inner highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius * 0.6, highlightPaint);
  }
}
