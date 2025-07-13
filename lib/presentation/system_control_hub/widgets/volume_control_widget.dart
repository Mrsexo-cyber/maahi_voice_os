import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VolumeControlWidget extends StatefulWidget {
  final double volume;
  final ValueChanged<double> onVolumeChanged;

  const VolumeControlWidget({
    Key? key,
    required this.volume,
    required this.onVolumeChanged,
  }) : super(key: key);

  @override
  State<VolumeControlWidget> createState() => _VolumeControlWidgetState();
}

class _VolumeControlWidgetState extends State<VolumeControlWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String get _volumeLevel {
    if (widget.volume == 0) return 'Muted';
    if (widget.volume < 30) return 'Low';
    if (widget.volume < 70) return 'Medium';
    return 'High';
  }

  String get _volumeIcon {
    if (widget.volume == 0) return 'volume_off';
    if (widget.volume < 30) return 'volume_down';
    if (widget.volume < 70) return 'volume_up';
    return 'volume_up';
  }

  Color get _volumeColor {
    if (widget.volume == 0) return AppTheme.errorRed;
    if (widget.volume < 30) return AppTheme.warningAmber;
    if (widget.volume < 70) return AppTheme.primaryCyan;
    return AppTheme.successGreen;
  }

  void _toggleMute() {
    if (widget.volume > 0) {
      widget.onVolumeChanged(0);
    } else {
      widget.onVolumeChanged(50);
    }
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
              GestureDetector(
                onTap: _toggleMute,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isDragging ? _pulseAnimation.value : 1.0,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: _volumeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _volumeColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: _volumeIcon,
                          color: _volumeColor,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Volume Control',
                      style: AppTheme.darkTheme.textTheme.titleMedium,
                    ),
                    Text(
                      '$_volumeLevel (${widget.volume.toInt()}%)',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: _volumeColor,
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
                      'volume badhao/kam karo',
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

          // Volume slider with visual feedback
          Row(
            children: [
              // Mute button
              GestureDetector(
                onTap: _toggleMute,
                child: Container(
                  padding: EdgeInsets.all(1.5.w),
                  decoration: BoxDecoration(
                    color: widget.volume == 0
                        ? AppTheme.errorRed.withValues(alpha: 0.2)
                        : AppTheme.deepCharcoal,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.volume == 0
                          ? AppTheme.errorRed
                          : AppTheme.borderColor,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'volume_off',
                    color: widget.volume == 0
                        ? AppTheme.errorRed
                        : AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),

              // Custom volume slider
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6.0,
                    thumbShape: VolumeSliderThumb(
                      thumbRadius: 12.0,
                      color: _volumeColor,
                      isDragging: _isDragging,
                    ),
                    overlayShape: RoundSliderOverlayShape(
                      overlayRadius: _isDragging ? 20.0 : 16.0,
                    ),
                    overlayColor: _volumeColor.withValues(alpha: 0.2),
                    activeTrackColor: _volumeColor,
                    inactiveTrackColor: AppTheme.borderColor,
                    thumbColor: _volumeColor,
                  ),
                  child: Slider(
                    value: widget.volume,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    onChangeStart: (value) {
                      setState(() {
                        _isDragging = true;
                      });
                      _pulseController.repeat(reverse: true);
                    },
                    onChangeEnd: (value) {
                      setState(() {
                        _isDragging = false;
                      });
                      _pulseController.stop();
                      _pulseController.reset();
                    },
                    onChanged: widget.onVolumeChanged,
                  ),
                ),
              ),

              SizedBox(width: 3.w),
              // Max volume button
              GestureDetector(
                onTap: () => widget.onVolumeChanged(100),
                child: Container(
                  padding: EdgeInsets.all(1.5.w),
                  decoration: BoxDecoration(
                    color: widget.volume == 100
                        ? AppTheme.successGreen.withValues(alpha: 0.2)
                        : AppTheme.deepCharcoal,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.volume == 100
                          ? AppTheme.successGreen
                          : AppTheme.borderColor,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'volume_up',
                    color: widget.volume == 100
                        ? AppTheme.successGreen
                        : AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Volume type indicators
          Row(
            children: [
              _buildVolumeTypeIndicator(
                'Media',
                'music_note',
                widget.volume,
                true,
              ),
              SizedBox(width: 3.w),
              _buildVolumeTypeIndicator(
                'Ring',
                'ring_volume',
                widget.volume * 0.8,
                false,
              ),
              SizedBox(width: 3.w),
              _buildVolumeTypeIndicator(
                'Alarm',
                'alarm',
                widget.volume * 0.9,
                false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeTypeIndicator(
    String label,
    String iconName,
    double value,
    bool isActive,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isActive
              ? _volumeColor.withValues(alpha: 0.1)
              : AppTheme.deepCharcoal,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? _volumeColor.withValues(alpha: 0.3)
                : AppTheme.borderColor,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isActive ? _volumeColor : AppTheme.textSecondary,
              size: 16,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                color: isActive ? _volumeColor : AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 0.5.h),
            LinearProgressIndicator(
              value: value / 100,
              backgroundColor: AppTheme.borderColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                isActive ? _volumeColor : AppTheme.textSecondary,
              ),
              minHeight: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class VolumeSliderThumb extends SliderComponentShape {
  final double thumbRadius;
  final Color color;
  final bool isDragging;

  const VolumeSliderThumb({
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

    // Draw outer ring when dragging
    if (isDragging) {
      final ringPaint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(center, thumbRadius + 6, ringPaint);
    }

    // Draw main thumb
    final thumbPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius, thumbPaint);

    // Draw volume icon in center
    final iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Simple volume bars representation
    final barWidth = thumbRadius * 0.2;
    final barSpacing = thumbRadius * 0.15;
    final startX = center.dx - (barWidth * 1.5 + barSpacing);

    for (int i = 0; i < 3; i++) {
      final barHeight = thumbRadius * (0.4 + i * 0.2);
      final barRect = Rect.fromLTWH(
        startX + i * (barWidth + barSpacing),
        center.dy - barHeight / 2,
        barWidth,
        barHeight,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(barRect, const Radius.circular(1)),
        iconPaint,
      );
    }
  }
}
