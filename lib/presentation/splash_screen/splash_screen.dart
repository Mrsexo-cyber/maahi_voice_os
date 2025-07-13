import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _waveformAnimationController;
  late AnimationController _loadingAnimationController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _waveformAnimation;
  late Animation<double> _loadingAnimation;

  String _loadingText = "Initializing MAAHI...";
  double _loadingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
    _hideSystemUI();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Waveform animation controller
    _waveformAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    // Waveform animation
    _waveformAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveformAnimationController,
      curve: Curves.easeInOut,
    ));

    // Loading progress animation
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoAnimationController.repeat(reverse: true);
    _waveformAnimationController.repeat();
    _loadingAnimationController.forward();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _startInitialization() async {
    // Simulate initialization process
    await _simulateInitializationSteps();

    // Navigate based on user state
    _navigateToNextScreen();
  }

  Future<void> _simulateInitializationSteps() async {
    final steps = [
      "Checking microphone permissions...",
      "Loading offline voice models...",
      "Verifying accessibility service...",
      "Preparing encrypted storage...",
      "Initializing voice engine...",
      "Ready to assist, Boss!"
    ];

    for (int i = 0; i < steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _loadingText = steps[i];
          _loadingProgress = (i + 1) / steps.length;
        });
      }
    }
  }

  void _navigateToNextScreen() {
    // Simulate user state check
    final bool isFirstTime = true; // Mock data
    final bool hasPermissions = false; // Mock data
    final bool isSetupComplete = false; // Mock data

    String nextRoute;

    if (isFirstTime) {
      nextRoute = '/onboarding-flow';
    } else if (!hasPermissions) {
      nextRoute = '/permission-setup-wizard';
    } else if (isSetupComplete) {
      nextRoute = '/floating-hud-dashboard';
    } else {
      nextRoute = '/voice-command-center';
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, nextRoute);
      }
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _waveformAnimationController.dispose();
    _loadingAnimationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.trueDarkBackground,
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: _buildBackgroundDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimatedLogo(),
                      SizedBox(height: 8.h),
                      _buildWaveformVisualization(),
                      SizedBox(height: 6.h),
                      _buildLoadingSection(),
                    ],
                  ),
                ),
              ),
              _buildBottomBranding(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.trueDarkBackground,
          AppTheme.deepCharcoal.withValues(alpha: 0.8),
          AppTheme.trueDarkBackground,
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Opacity(
            opacity: _logoOpacityAnimation.value,
            child: Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primaryCyan.withValues(alpha: 0.8),
                    AppTheme.tealAccent.withValues(alpha: 0.6),
                    AppTheme.primaryCyan.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryCyan.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'MAAHI',
                  style: AppTheme.dataTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaveformVisualization() {
    return AnimatedBuilder(
      animation: _waveformAnimationController,
      builder: (context, child) {
        return SizedBox(
          width: 60.w,
          height: 8.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(12, (index) {
              final double animationOffset = (index * 0.1) % 1.0;
              final double waveHeight = (1.0 +
                      (0.8 *
                          (_waveformAnimation.value + animationOffset) %
                          1.0)) *
                  3.h;

              return Container(
                width: 0.8.w,
                height: waveHeight,
                decoration: BoxDecoration(
                  color: AppTheme
                      .waveformColors[index % AppTheme.waveformColors.length],
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryCyan.withValues(alpha: 0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        Container(
          width: 70.w,
          height: 0.5.h,
          decoration: BoxDecoration(
            color: AppTheme.borderColor,
            borderRadius: BorderRadius.circular(2),
          ),
          child: AnimatedBuilder(
            animation: _loadingAnimation,
            builder: (context, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _loadingProgress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryCyan,
                        AppTheme.tealAccent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryCyan.withValues(alpha: 0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          _loadingText,
          style: AppTheme.dataTextStyle(
            fontSize: 12.sp,
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        Text(
          '${(_loadingProgress * 100).toInt()}%',
          style: AppTheme.dataTextStyle(
            fontSize: 10.sp,
            color: AppTheme.primaryCyan,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBranding() {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Column(
        children: [
          Text(
            'MAAHI Voice OS',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your Intelligent Voice Assistant',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textDisabled,
            ),
          ),
        ],
      ),
    );
  }
}
