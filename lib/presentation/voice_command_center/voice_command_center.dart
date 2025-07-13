import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/command_category_widget.dart';
import './widgets/command_history_item_widget.dart';
import './widgets/training_session_widget.dart';
import './widgets/voice_settings_widget.dart';
import './widgets/voice_waveform_widget.dart';

class VoiceCommandCenter extends StatefulWidget {
  const VoiceCommandCenter({Key? key}) : super(key: key);

  @override
  State<VoiceCommandCenter> createState() => _VoiceCommandCenterState();
}

class _VoiceCommandCenterState extends State<VoiceCommandCenter>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isListening = false;
  String _currentTranscription = "Say 'Hey Maahi' to start...";
  final TextEditingController _searchController = TextEditingController();

  // Mock data for command categories
  final List<Map<String, dynamic>> commandCategories = [
    {
      "id": 1,
      "title": "App Control",
      "icon": "apps",
      "commands": [
        {
          "phrase": "WhatsApp kholo",
          "description": "Open WhatsApp",
          "success": true
        },
        {
          "phrase": "Instagram band karo",
          "description": "Close Instagram",
          "success": true
        },
        {
          "phrase": "Camera start karo",
          "description": "Launch Camera",
          "success": false
        },
      ],
      "isExpanded": false,
    },
    {
      "id": 2,
      "title": "System Settings",
      "icon": "settings",
      "commands": [
        {
          "phrase": "brightness kam karo",
          "description": "Decrease brightness",
          "success": true
        },
        {
          "phrase": "WiFi on karo",
          "description": "Enable WiFi",
          "success": true
        },
        {
          "phrase": "volume badha do",
          "description": "Increase volume",
          "success": true
        },
      ],
      "isExpanded": false,
    },
    {
      "id": 3,
      "title": "Communication",
      "icon": "message",
      "commands": [
        {
          "phrase": "message padho",
          "description": "Read messages",
          "success": true
        },
        {
          "phrase": "call karo mom ko",
          "description": "Call mom",
          "success": false
        },
        {"phrase": "SMS bhejo", "description": "Send SMS", "success": true},
      ],
      "isExpanded": false,
    },
    {
      "id": 4,
      "title": "Media",
      "icon": "play_circle_filled",
      "commands": [
        {
          "phrase": "music play karo",
          "description": "Play music",
          "success": true
        },
        {
          "phrase": "video record karo",
          "description": "Record video",
          "success": true
        },
        {
          "phrase": "screenshot lo",
          "description": "Take screenshot",
          "success": false
        },
      ],
      "isExpanded": false,
    },
    {
      "id": 5,
      "title": "Automation",
      "icon": "auto_awesome",
      "commands": [
        {
          "phrase": "study mode on",
          "description": "Enable study mode",
          "success": true
        },
        {
          "phrase": "DND activate karo",
          "description": "Activate Do Not Disturb",
          "success": true
        },
        {
          "phrase": "battery save karo",
          "description": "Enable battery saver",
          "success": true
        },
      ],
      "isExpanded": false,
    },
  ];

  // Mock data for command history
  final List<Map<String, dynamic>> commandHistory = [
    {
      "id": 1,
      "timestamp": DateTime.now().subtract(Duration(minutes: 5)),
      "recognizedText": "brightness kam karo",
      "executedAction": "Brightness decreased to 30%",
      "success": true,
      "category": "System Settings",
    },
    {
      "id": 2,
      "timestamp": DateTime.now().subtract(Duration(minutes: 12)),
      "recognizedText": "WhatsApp kholo",
      "executedAction": "WhatsApp launched successfully",
      "success": true,
      "category": "App Control",
    },
    {
      "id": 3,
      "timestamp": DateTime.now().subtract(Duration(minutes: 18)),
      "recognizedText": "music play karo",
      "executedAction": "Music player opened",
      "success": true,
      "category": "Media",
    },
    {
      "id": 4,
      "timestamp": DateTime.now().subtract(Duration(minutes: 25)),
      "recognizedText": "camera start karo",
      "executedAction": "Failed: Camera permission denied",
      "success": false,
      "category": "App Control",
    },
    {
      "id": 5,
      "timestamp": DateTime.now().subtract(Duration(hours: 1)),
      "recognizedText": "call karo mom ko",
      "executedAction": "Failed: Contact not found",
      "success": false,
      "category": "Communication",
    },
  ];

  // Mock data for training sessions
  final List<Map<String, dynamic>> trainingSessions = [
    {
      "id": 1,
      "title": "Custom App Launch",
      "description": "Train MAAHI to recognize your custom app names",
      "progress": 0.75,
      "isCompleted": false,
      "estimatedTime": "5 min",
    },
    {
      "id": 2,
      "title": "Personal Contacts",
      "description": "Teach voice recognition for your contact names",
      "progress": 1.0,
      "isCompleted": true,
      "estimatedTime": "3 min",
    },
    {
      "id": 3,
      "title": "Custom Macros",
      "description": "Create personalized command sequences",
      "progress": 0.0,
      "isCompleted": false,
      "estimatedTime": "8 min",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
      if (_isListening) {
        _currentTranscription = "Listening... Speak now";
        // Simulate voice recognition
        Future.delayed(Duration(seconds: 3), () {
          if (mounted && _isListening) {
            setState(() {
              _currentTranscription = "brightness kam karo";
            });
          }
        });
      } else {
        _currentTranscription = "Say 'Hey Maahi' to start...";
      }
    });
  }

  void _toggleCategoryExpansion(int categoryId) {
    setState(() {
      final categoryIndex =
          commandCategories.indexWhere((cat) => cat["id"] == categoryId);
      if (categoryIndex != -1) {
        commandCategories[categoryIndex]["isExpanded"] =
            !commandCategories[categoryIndex]["isExpanded"];
      }
    });
  }

  void _createNewCommand() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.elevatedSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 10.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                "Create New Command",
                style: AppTheme.darkTheme.textTheme.headlineSmall,
              ),
              SizedBox(height: 2.h),
              Text(
                "Follow the steps to create your personalized voice command",
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 4.h),
              Expanded(
                child: ListView(
                  children: [
                    _buildCommandStep(
                      stepNumber: 1,
                      title: "Record Voice Command",
                      description: "Say the phrase you want MAAHI to recognize",
                      icon: "mic",
                    ),
                    SizedBox(height: 2.h),
                    _buildCommandStep(
                      stepNumber: 2,
                      title: "Define Action",
                      description: "Choose what action should be performed",
                      icon: "play_arrow",
                    ),
                    SizedBox(height: 2.h),
                    _buildCommandStep(
                      stepNumber: 3,
                      title: "Test & Save",
                      description: "Test your command and save it",
                      icon: "check_circle",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Start Creating"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommandStep({
    required int stepNumber,
    required String title,
    required String description,
    required String icon,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.deepCharcoal,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryCyan.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryCyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.primaryCyan,
            size: 24,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.trueDarkBackground,
      appBar: AppBar(
        title: Text("Voice Command Center"),
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
              iconName: 'dashboard',
              color: AppTheme.textPrimary,
              size: 24,
            ),
            onPressed: () =>
                Navigator.pushNamed(context, '/floating-hud-dashboard'),
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.textPrimary,
              size: 24,
            ),
            onPressed: () =>
                Navigator.pushNamed(context, '/system-control-hub'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Commands"),
            Tab(text: "History"),
            Tab(text: "Training"),
            Tab(text: "Settings"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Voice Recognition Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.elevatedSurface,
              border: Border(
                bottom: BorderSide(color: AppTheme.borderColor),
              ),
            ),
            child: Column(
              children: [
                VoiceWaveformWidget(
                  isListening: _isListening,
                  onTap: _toggleListening,
                ),
                SizedBox(height: 2.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.deepCharcoal,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isListening
                          ? AppTheme.primaryCyan
                          : AppTheme.borderColor,
                    ),
                  ),
                  child: Text(
                    _currentTranscription,
                    style: AppTheme.dataTextStyle(
                      fontSize: 16,
                      color: _isListening
                          ? AppTheme.primaryCyan
                          : AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCommandsTab(),
                _buildHistoryTab(),
                _buildTrainingTab(),
                _buildSettingsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewCommand,
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.trueDarkBackground,
          size: 24,
        ),
        label: Text("New Command"),
      ),
    );
  }

  Widget _buildCommandsTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
      },
      child: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(4.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search commands or say 'find brightness commands'",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: CustomIconWidget(
                    iconName: 'mic',
                    color: AppTheme.primaryCyan,
                    size: 20,
                  ),
                  onPressed: () {
                    // Voice search functionality
                  },
                ),
              ),
            ),
          ),
          // Command Categories
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: commandCategories.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final category = commandCategories[index];
                return CommandCategoryWidget(
                  category: category,
                  onToggleExpansion: () =>
                      _toggleCategoryExpansion(category["id"]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
      },
      child: ListView.separated(
        padding: EdgeInsets.all(4.w),
        itemCount: commandHistory.length,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final historyItem = commandHistory[index];
          return CommandHistoryItemWidget(
            historyItem: historyItem,
            onDelete: () {
              setState(() {
                commandHistory.removeAt(index);
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildTrainingTab() {
    return ListView.separated(
      padding: EdgeInsets.all(4.w),
      itemCount: trainingSessions.length + 1,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppTheme.primaryCyan.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'school',
                      color: AppTheme.primaryCyan,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      "Voice Training Hub",
                      style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryCyan,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  "Improve MAAHI's understanding of your voice and create personalized commands",
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        final session = trainingSessions[index - 1];
        return TrainingSessionWidget(
          session: session,
          onStart: () {
            // Start training session
          },
        );
      },
    );
  }

  Widget _buildSettingsTab() {
    return VoiceSettingsWidget();
  }
}
