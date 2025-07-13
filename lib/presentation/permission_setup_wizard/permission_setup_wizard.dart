import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/completion_celebration_widget.dart';
import './widgets/permission_step_widget.dart';
import './widgets/progress_indicator_widget.dart';

class PermissionSetupWizard extends StatefulWidget {
  const PermissionSetupWizard({Key? key}) : super(key: key);

  @override
  State<PermissionSetupWizard> createState() => _PermissionSetupWizardState();
}

class _PermissionSetupWizardState extends State<PermissionSetupWizard> {
  int currentStep = 0;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> permissionSteps = [
    {
      "id": 1,
      "title": "Microphone Access",
      "icon": "mic",
      "description": "Enable voice commands and wake word detection",
      "benefit": "Control your phone with voice - 'Hey Maahi, open WhatsApp'",
      "isRequired": true,
      "isGranted": false,
      "concerns": "Your voice data is processed locally on device for privacy",
    },
    {
      "id": 2,
      "title": "Accessibility Service",
      "icon": "accessibility",
      "description": "Allow MAAHI to interact with your device interface",
      "benefit":
          "Automate app actions, tap buttons, and navigate screens with voice",
      "isRequired": true,
      "isGranted": false,
      "concerns": "Required for advanced automation - fully secure and private",
    },
    {
      "id": 3,
      "title": "Device Administrator",
      "icon": "admin_panel_settings",
      "description": "Enable system-level controls and security features",
      "benefit":
          "Lock device, control brightness, manage Wi-Fi with voice commands",
      "isRequired": true,
      "isGranted": false,
      "concerns":
          "Provides secure system access without compromising your data",
    },
    {
      "id": 4,
      "title": "Camera Access",
      "icon": "camera_alt",
      "description": "Capture intruder photos and enable visual features",
      "benefit":
          "Security monitoring and enhanced voice interaction capabilities",
      "isRequired": false,
      "isGranted": false,
      "concerns": "Only used for security features - no unauthorized recording",
    },
    {
      "id": 5,
      "title": "Storage Access",
      "icon": "storage",
      "description": "Manage files, clean cache, and organize your device",
      "benefit": "Voice-controlled file management and storage optimization",
      "isRequired": false,
      "isGranted": false,
      "concerns": "Access limited to cleaning and optimization tasks only",
    },
  ];

  bool get isLastStep => currentStep >= permissionSteps.length;
  bool get canContinue =>
      currentStep < permissionSteps.length &&
      (permissionSteps[currentStep]["isGranted"] ||
          !permissionSteps[currentStep]["isRequired"]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.trueDarkBackground,
      body: SafeArea(
        child: isLastStep ? _buildCompletionScreen() : _buildPermissionFlow(),
      ),
    );
  }

  Widget _buildPermissionFlow() {
    return Column(
      children: [
        _buildHeader(),
        SizedBox(height: 3.h),
        ProgressIndicatorWidget(
          currentStep: currentStep + 1,
          totalSteps: permissionSteps.length,
          completedSteps:
              permissionSteps.where((step) => step["isGranted"]).length,
        ),
        SizedBox(height: 4.h),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentStep = index;
              });
            },
            itemCount: permissionSteps.length,
            itemBuilder: (context, index) {
              return PermissionStepWidget(
                permissionData: permissionSteps[index],
                onGrantPermission: () => _handleGrantPermission(index),
                onSkip: () => _handleSkipPermission(index),
              );
            },
          ),
        ),
        _buildBottomNavigation(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: _handleBack,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.elevatedSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.textPrimary,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Permission Setup",
                  style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "Grant permissions for full MAAHI experience",
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.primaryCyan.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppTheme.primaryCyan.withValues(alpha: 0.3)),
            ),
            child: Text(
              "${currentStep + 1} of ${permissionSteps.length}",
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.primaryCyan,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.deepCharcoal,
        border: Border(
          top: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _handleBack,
                style: AppTheme.darkTheme.outlinedButtonTheme.style?.copyWith(
                  side: WidgetStateProperty.all(
                    BorderSide(color: AppTheme.borderColor, width: 1),
                  ),
                  foregroundColor:
                      WidgetStateProperty.all(AppTheme.textSecondary),
                ),
                child: Text("Back"),
              ),
            ),
          if (currentStep > 0) SizedBox(width: 4.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: canContinue ? _handleContinue : null,
              style: AppTheme.darkTheme.elevatedButtonTheme.style?.copyWith(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.disabled)) {
                    return AppTheme.borderColor;
                  }
                  return AppTheme.primaryCyan;
                }),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(currentStep == permissionSteps.length - 1
                      ? "Complete Setup"
                      : "Continue"),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'arrow_forward',
                    color: AppTheme.trueDarkBackground,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen() {
    return CompletionCelebrationWidget(
      onStartUsingMaahi: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/floating-hud-dashboard',
          (route) => false,
        );
      },
    );
  }

  void _handleGrantPermission(int stepIndex) {
    setState(() {
      permissionSteps[stepIndex]["isGranted"] = true;
    });

    // Simulate permission dialog
    _showPermissionDialog(stepIndex);
  }

  void _handleSkipPermission(int stepIndex) {
    if (permissionSteps[stepIndex]["isRequired"]) {
      _showSkipWarningDialog(stepIndex);
    } else {
      _handleContinue();
    }
  }

  void _handleBack() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _handleContinue() {
    if (currentStep < permissionSteps.length - 1) {
      setState(() {
        currentStep++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() {
        currentStep = permissionSteps.length;
      });
    }
  }

  void _showPermissionDialog(int stepIndex) {
    final permission = permissionSteps[stepIndex];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.elevatedSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: permission["icon"],
              color: AppTheme.primaryCyan,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              "Grant ${permission['title']}?",
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          "MAAHI needs ${permission['title'].toLowerCase()} to ${permission['description'].toLowerCase()}. This enables: ${permission['benefit']}",
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                permissionSteps[stepIndex]["isGranted"] = false;
              });
            },
            child: Text("Deny"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                permissionSteps[stepIndex]["isGranted"] = true;
              });
            },
            child: Text("Allow"),
          ),
        ],
      ),
    );
  }

  void _showSkipWarningDialog(int stepIndex) {
    final permission = permissionSteps[stepIndex];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.elevatedSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.warningAmber,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              "Required Permission",
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          "${permission['title']} is required for MAAHI to function properly. Without this permission, you'll have limited functionality.",
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Go Back"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleContinue();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.warningAmber,
            ),
            child: Text("Skip Anyway"),
          ),
        ],
      ),
    );
  }
}
