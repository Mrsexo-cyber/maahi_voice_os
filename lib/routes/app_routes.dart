import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/permission_setup_wizard/permission_setup_wizard.dart';
import '../presentation/floating_hud_dashboard/floating_hud_dashboard.dart';
import '../presentation/voice_command_center/voice_command_center.dart';
import '../presentation/system_control_hub/system_control_hub.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String permissionSetupWizard = '/permission-setup-wizard';
  static const String floatingHudDashboard = '/floating-hud-dashboard';
  static const String voiceCommandCenter = '/voice-command-center';
  static const String systemControlHub = '/system-control-hub';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    permissionSetupWizard: (context) => const PermissionSetupWizard(),
    floatingHudDashboard: (context) => const FloatingHudDashboard(),
    voiceCommandCenter: (context) => const VoiceCommandCenter(),
    systemControlHub: (context) => const SystemControlHub(),
    // TODO: Add your other routes here
  };
}
