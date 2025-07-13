import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/expanded_dashboard_widget.dart';
import './widgets/floating_hud_widget.dart';

class FloatingHudDashboard extends StatefulWidget {
  const FloatingHudDashboard({Key? key}) : super(key: key);

  @override
  State<FloatingHudDashboard> createState() => _FloatingHudDashboardState();
}

class _FloatingHudDashboardState extends State<FloatingHudDashboard>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isListening = false;
  bool _isHudVisible = true;
  Offset _hudPosition = Offset(80.w, 20.h);

  late AnimationController _waveformController;
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  // Mock system data
  final Map<String, dynamic> _systemData = {
    "ramUsage": 68.5,
    "batteryPercentage": 87,
    "cpuTemperature": 42.3,
    "networkStatus": "WiFi Connected",
    "isCharging": false,
    "storageUsed": 45.2,
    "activeApps": 12,
    "lastCommand": "Hey MAAHI, increase brightness",
    "personality": "Desi Obedient",
    "voiceMode": "Active"
  };

  final List<Map<String, dynamic>> _quickActions = [
    {
      "id": 1,
      "title": "Brightness",
      "icon": "brightness_6",
      "value": 75,
      "type": "slider"
    },
    {
      "id": 2,
      "title": "Volume",
      "icon": "volume_up",
      "value": 60,
      "type": "slider"
    },
    {
      "id": 3,
      "title": "Wi-Fi",
      "icon": "wifi",
      "isEnabled": true,
      "type": "toggle"
    },
    {
      "id": 4,
      "title": "Bluetooth",
      "icon": "bluetooth",
      "isEnabled": false,
      "type": "toggle"
    }
  ];

  final List<Map<String, dynamic>> _recentCommands = [
    {
      "id": 1,
      "command": "Hey MAAHI, open WhatsApp",
      "timestamp": "2 minutes ago",
      "status": "completed"
    },
    {
      "id": 2,
      "command": "MAAHI, set timer for 10 minutes",
      "timestamp": "5 minutes ago",
      "status": "completed"
    },
    {
      "id": 3,
      "command": "Hey MAAHI, read my messages",
      "timestamp": "8 minutes ago",
      "status": "completed"
    }
  ];

  final List<Map<String, dynamic>> _activeRoutines = [
    {
      "id": 1,
      "name": "Study Mode",
      "isActive": true,
      "description": "DND enabled, apps blocked"
    },
    {
      "id": 2,
      "name": "Gaming Mode",
      "isActive": false,
      "description": "Performance optimized"
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _simulateVoiceActivity();
  }

  void _initializeAnimations() {
    _waveformController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
  }

  void _simulateVoiceActivity() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isListening = true;
        });
        _waveformController.repeat();

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isListening = false;
            });
            _waveformController.stop();
          }
        });
      }
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  void _showContextMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildContextMenu(),
    );
  }

  Widget _buildContextMenu() {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: AppTheme.glassmorphismDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          _buildContextMenuItem("Settings", "settings", () {
            Navigator.pop(context);
            // Navigate to settings
          }),
          _buildContextMenuItem("Privacy Mode", "security", () {
            Navigator.pop(context);
            // Toggle privacy mode
          }),
          _buildContextMenuItem("Personality Switch", "person", () {
            Navigator.pop(context);
            // Show personality options
          }),
          _buildContextMenuItem("Hide HUD", "visibility_off", () {
            Navigator.pop(context);
            setState(() {
              _isHudVisible = false;
            });
          }),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildContextMenuItem(String title, String icon, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: AppTheme.primaryCyan,
        size: 6.w,
      ),
      title: Text(
        title,
        style: AppTheme.darkTheme.textTheme.bodyLarge,
      ),
      onTap: onTap,
    );
  }

  @override
  void dispose() {
    _waveformController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.trueDarkBackground,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.trueDarkBackground,
                  AppTheme.deepCharcoal.withValues(alpha: 0.8),
                  AppTheme.trueDarkBackground,
                ],
              ),
            ),
          ),

          // Floating HUD
          if (_isHudVisible)
            AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, child) {
                return _isExpanded
                    ? ExpandedDashboardWidget(
                        systemData: _systemData,
                        quickActions: _quickActions,
                        recentCommands: _recentCommands,
                        activeRoutines: _activeRoutines,
                        onCollapse: _toggleExpanded,
                        isListening: _isListening,
                        waveformController: _waveformController,
                      )
                    : Positioned(
                        left: _hudPosition.dx,
                        top: _hudPosition.dy,
                        child: FloatingHudWidget(
                          systemData: _systemData,
                          isListening: _isListening,
                          waveformController: _waveformController,
                          onTap: _toggleExpanded,
                          onLongPress: _showContextMenu,
                          onPanUpdate: (details) {
                            setState(() {
                              _hudPosition += details.delta;

                              // Keep HUD within screen bounds
                              _hudPosition = Offset(
                                _hudPosition.dx.clamp(0, 100.w - 20.w),
                                _hudPosition.dy.clamp(0, 100.h - 20.h),
                              );
                            });
                          },
                        ),
                      );
              },
            ),

          // Navigation buttons (when HUD is hidden)
          if (!_isHudVisible)
            Positioned(
              bottom: 4.h,
              right: 4.w,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _isHudVisible = true;
                  });
                },
                backgroundColor: AppTheme.primaryCyan,
                child: CustomIconWidget(
                  iconName: 'visibility',
                  color: AppTheme.trueDarkBackground,
                  size: 6.w,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
