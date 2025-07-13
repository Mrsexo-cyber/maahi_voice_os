import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/automation_tab_widget.dart';
import './widgets/monitoring_tab_widget.dart';
import './widgets/quick_controls_tab_widget.dart';
import './widgets/voice_feedback_widget.dart';

class SystemControlHub extends StatefulWidget {
  const SystemControlHub({Key? key}) : super(key: key);

  @override
  State<SystemControlHub> createState() => _SystemControlHubState();
}

class _SystemControlHubState extends State<SystemControlHub>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isVoiceActive = false;
  String _currentVoiceCommand = '';
  
  // Mock system status data
  final Map<String, dynamic> _systemStatus = {
    "brightness": 75.0,
    "volume": 60.0,
    "wifi_enabled": true,
    "bluetooth_enabled": false,
    "dnd_enabled": false,
    "screen_locked": false,
    "ram_usage": 68.5,
    "storage_used": 45.2,
    "battery_level": 82,
    "cpu_usage": 34.7,
    "last_updated": DateTime.now(),
  };

  final List<Map<String, dynamic>> _voiceCommands = [
{ "command": "brightness badhao",
"action": "increase_brightness",
"description": "Increase screen brightness" },
{ "command": "volume kam karo",
"action": "decrease_volume",
"description": "Decrease volume level" },
{ "command": "wifi band karo",
"action": "toggle_wifi",
"description": "Turn off Wi-Fi" },
{ "command": "bluetooth on karo",
"action": "enable_bluetooth",
"description": "Enable Bluetooth" },
{ "command": "do not disturb on",
"action": "enable_dnd",
"description": "Enable Do Not Disturb" },
{ "command": "phone lock karo",
"action": "lock_screen",
"description": "Lock the device" },
{ "command": "ram clean karo",
"action": "clean_ram",
"description": "Clean RAM memory" },
];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _simulateVoiceListening();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _simulateVoiceListening() {
    // Simulate periodic voice command detection
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isVoiceActive = !_isVoiceActive;
          if (_isVoiceActive) {
            _currentVoiceCommand = _voiceCommands[
                DateTime.now().millisecond % _voiceCommands.length
            ]["command"] as String;
          } else {
            _currentVoiceCommand = '';
          }
        });
        _simulateVoiceListening();
      }
    });
  }

  void _executeVoiceCommand(String command) {
    setState(() {
      switch (command) {
        case "increase_brightness":
          _systemStatus["brightness"] = 
              ((_systemStatus["brightness"] as double) + 10).clamp(0, 100);
          break;
        case "decrease_volume":
          _systemStatus["volume"] = 
              ((_systemStatus["volume"] as double) - 10).clamp(0, 100);
          break;
        case "toggle_wifi":
          _systemStatus["wifi_enabled"] = !(_systemStatus["wifi_enabled"] as bool);
          break;
        case "enable_bluetooth":
          _systemStatus["bluetooth_enabled"] = true;
          break;
        case "enable_dnd":
          _systemStatus["dnd_enabled"] = true;
          break;
        case "lock_screen":
          _systemStatus["screen_locked"] = true;
          break;
        case "clean_ram":
          _systemStatus["ram_usage"] = 
              ((_systemStatus["ram_usage"] as double) * 0.7).clamp(0, 100);
          break;
      }
      _systemStatus["last_updated"] = DateTime.now();
    });
  }

  Future<void> _refreshSystemStatus() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _systemStatus["last_updated"] = DateTime.now();
      // Simulate some random changes
      _systemStatus["cpu_usage"] = 
          (20 + DateTime.now().millisecond % 40).toDouble();
      _systemStatus["ram_usage"] = 
          (40 + DateTime.now().millisecond % 30).toDouble();
    });
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.elevatedSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Voice Actions',
                    style: AppTheme.darkTheme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 2.h),
                  ...(_voiceCommands.take(4).map((cmd) => ListTile(
                    leading: CustomIconWidget(
                      iconName: 'mic',
                      color: AppTheme.primaryCyan,
                      size: 24,
                    ),
                    title: Text(
                      '"${cmd["command"]}"',
                      style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.primaryCyan,
                      ),
                    ),
                    subtitle: Text(
                      cmd["description"] as String,
                      style: AppTheme.darkTheme.textTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _executeVoiceCommand(cmd["action"] as String);
                    },
                  ))),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.trueDarkBackground,
      appBar: AppBar(
        title: Text(
          'System Control Hub',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.trueDarkBackground,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimary,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: _isVoiceActive ? 'mic' : 'mic_off',
              color: _isVoiceActive ? AppTheme.primaryCyan : AppTheme.textSecondary,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _isVoiceActive = !_isVoiceActive;
              });
            },
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.textSecondary,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/voice-command-center');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Quick Controls'),
            Tab(text: 'Automation'),
            Tab(text: 'Monitoring'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSystemStatus,
        color: AppTheme.primaryCyan,
        backgroundColor: AppTheme.elevatedSurface,
        child: Column(
          children: [
            if (_isVoiceActive && _currentVoiceCommand.isNotEmpty)
              VoiceFeedbackWidget(
                command: _currentVoiceCommand,
                isActive: _isVoiceActive,
              ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  QuickControlsTabWidget(
                    systemStatus: _systemStatus,
                    onSystemUpdate: (key, value) {
                      setState(() {
                        _systemStatus[key] = value;
                        _systemStatus["last_updated"] = DateTime.now();
                      });
                    },
                  ),
                  AutomationTabWidget(
                    systemStatus: _systemStatus,
                  ),
                  MonitoringTabWidget(
                    systemStatus: _systemStatus,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showQuickActions,
        backgroundColor: AppTheme.primaryCyan,
        foregroundColor: AppTheme.trueDarkBackground,
        icon: CustomIconWidget(
          iconName: 'flash_on',
          color: AppTheme.trueDarkBackground,
          size: 24,
        ),
        label: Text(
          'Quick Actions',
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.trueDarkBackground,
          ),
        ),
      ),
    );
  }
}