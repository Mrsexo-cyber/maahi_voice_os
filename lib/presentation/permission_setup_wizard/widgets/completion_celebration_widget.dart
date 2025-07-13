import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CompletionCelebrationWidget extends StatefulWidget {
  final VoidCallback onStartUsingMaahi;

  const CompletionCelebrationWidget({
    Key? key,
    required this.onStartUsingMaahi,
  }) : super(key: key);

  @override
  State<CompletionCelebrationWidget> createState() =>
      _CompletionCelebrationWidgetState();
}

class _CompletionCelebrationWidgetState
    extends State<CompletionCelebrationWidget> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    Future.delayed(Duration(milliseconds: 300), () {
      _scaleController.forward();
    });

    Future.delayed(Duration(milliseconds: 600), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            AppTheme.primaryCyan.withValues(alpha: 0.1),
            AppTheme.trueDarkBackground,
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.h),
            _buildCelebrationIcon(),
            SizedBox(height: 4.h),
            _buildSuccessMessage(),
            SizedBox(height: 3.h),
            _buildFeaturesList(),
            SizedBox(height: 6.h),
            _buildActionButton(),
            SizedBox(height: 4.h),
            _buildVoiceHint(),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrationIcon() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppTheme.primaryCyan,
                  AppTheme.tealAccent,
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryCyan.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.trueDarkBackground,
                  size: 60,
                ),
                Positioned(
                  top: 2.w,
                  right: 2.w,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: 'star',
                      color: AppTheme.textPrimary,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessMessage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          Text(
            "🎉 Setup Complete!",
            style: AppTheme.darkTheme.textTheme.headlineLarge?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            "MAAHI is ready to be your intelligent voice companion. All permissions are configured for the best experience.",
            style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final List<Map<String, String>> features = [
      {
        "icon": "mic",
        "title": "Voice Commands Ready",
        "description": "Say 'Hey Maahi' to start",
      },
      {
        "icon": "security",
        "title": "System Control Enabled",
        "description": "Control your device with voice",
      },
      {
        "icon": "smart_toy",
        "title": "AI Assistant Active",
        "description": "Intelligent responses in Hinglish",
      },
    ];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children:
            features.map((feature) => _buildFeatureItem(feature)).toList(),
      ),
    );
  }

  Widget _buildFeatureItem(Map<String, String> feature) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryCyan.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: feature["icon"]!,
              color: AppTheme.primaryCyan,
              size: 24,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature["title"]!,
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  feature["description"]!,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.successGreen,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: widget.onStartUsingMaahi,
          style: AppTheme.darkTheme.elevatedButtonTheme.style?.copyWith(
            padding: WidgetStateProperty.all(
              EdgeInsets.symmetric(vertical: 4.w),
            ),
            backgroundColor: WidgetStateProperty.all(AppTheme.primaryCyan),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'rocket_launch',
                color: AppTheme.trueDarkBackground,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                "Start Using MAAHI",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.trueDarkBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceHint() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.tealAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.tealAccent.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'volume_up',
              color: AppTheme.tealAccent,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                "Pro tip: You can also say 'start using maahi' to continue",
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.tealAccent,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
