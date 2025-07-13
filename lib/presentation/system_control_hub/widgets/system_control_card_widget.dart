import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SystemControlCardWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String iconName;
  final bool isEnabled;
  final String voiceCommand;
  final VoidCallback onTap;

  const SystemControlCardWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.isEnabled,
    required this.voiceCommand,
    required this.onTap,
  }) : super(key: key);

  @override
  State<SystemControlCardWidget> createState() =>
      _SystemControlCardWidgetState();
}

class _SystemControlCardWidgetState extends State<SystemControlCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  Color get _cardColor {
    if (widget.isEnabled) {
      return AppTheme.primaryCyan.withValues(alpha: 0.1);
    }
    return AppTheme.deepCharcoal;
  }

  Color get _borderColor {
    if (widget.isEnabled) {
      return AppTheme.primaryCyan.withValues(alpha: 0.3);
    }
    return AppTheme.borderColor;
  }

  Color get _iconColor {
    if (widget.isEnabled) {
      return AppTheme.primaryCyan;
    }
    return AppTheme.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.onTap,
            onLongPress: () {
              // Show voice command hint
              _showVoiceCommandHint();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _borderColor,
                  width: _isPressed ? 2 : 1,
                ),
                boxShadow: widget.isEnabled
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryCyan.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with status indicator
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: _iconColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomIconWidget(
                          iconName: widget.iconName,
                          color: _iconColor,
                          size: 32,
                        ),
                      ),
                      if (widget.isEnabled)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 3.w,
                            height: 3.w,
                            decoration: const BoxDecoration(
                              color: AppTheme.successGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Title
                  Text(
                    widget.title,
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 0.5.h),

                  // Subtitle with status
                  Text(
                    widget.subtitle,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: widget.isEnabled
                          ? AppTheme.primaryCyan
                          : AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 1.h),

                  // Toggle switch
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: widget.isEnabled,
                      onChanged: (value) => widget.onTap(),
                      activeColor: AppTheme.primaryCyan,
                      inactiveThumbColor: AppTheme.textSecondary,
                      inactiveTrackColor: AppTheme.borderColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showVoiceCommandHint() {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.3,
        left: 4.w,
        right: 4.w,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.elevatedSurface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowColor,
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'mic',
                      color: AppTheme.primaryCyan,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Voice Command',
                      style: AppTheme.darkTheme.textTheme.titleMedium,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => overlayEntry.remove(),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.deepCharcoal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '"${widget.voiceCommand}"',
                    style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.primaryCyan,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Say this command to control ${widget.title}',
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-remove after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
