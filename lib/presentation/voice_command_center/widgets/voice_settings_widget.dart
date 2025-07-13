import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceSettingsWidget extends StatefulWidget {
  const VoiceSettingsWidget({Key? key}) : super(key: key);

  @override
  State<VoiceSettingsWidget> createState() => _VoiceSettingsWidgetState();
}

class _VoiceSettingsWidgetState extends State<VoiceSettingsWidget> {
  double _wakeWordSensitivity = 0.7;
  double _responseVerbosity = 0.8;
  double _hinglishRatio = 0.6;
  bool _voiceOnlyNavigation = false;
  bool _offlineProcessing = true;
  bool _voiceFeedback = true;
  String _selectedPersonality = "Desi Obedient";
  String _selectedVoiceStyle = "Natural";

  final List<String> personalities = [
    "Desi Obedient",
    "Waifu Romantic",
    "Hacker Sharp",
    "Sassy Desi"
  ];

  final List<String> voiceStyles = ["Natural", "Formal", "Casual", "Energetic"];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(4.w),
      children: [
        // Voice Recognition Settings
        _buildSettingsSection(
          title: "Voice Recognition",
          icon: "mic",
          children: [
            _buildSliderSetting(
              title: "Wake Word Sensitivity",
              subtitle: "How easily 'Hey Maahi' triggers voice mode",
              value: _wakeWordSensitivity,
              onChanged: (value) =>
                  setState(() => _wakeWordSensitivity = value),
              min: 0.0,
              max: 1.0,
            ),
            SizedBox(height: 2.h),
            _buildSwitchSetting(
              title: "Offline Processing",
              subtitle: "Process voice commands locally for privacy",
              value: _offlineProcessing,
              onChanged: (value) => setState(() => _offlineProcessing = value),
            ),
            SizedBox(height: 2.h),
            _buildSwitchSetting(
              title: "Voice-Only Navigation",
              subtitle: "Navigate the app using only voice commands",
              value: _voiceOnlyNavigation,
              onChanged: (value) =>
                  setState(() => _voiceOnlyNavigation = value),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        // Response Settings
        _buildSettingsSection(
          title: "Response Settings",
          icon: "record_voice_over",
          children: [
            _buildSliderSetting(
              title: "Response Verbosity",
              subtitle: "How detailed MAAHI's responses should be",
              value: _responseVerbosity,
              onChanged: (value) => setState(() => _responseVerbosity = value),
              min: 0.0,
              max: 1.0,
            ),
            SizedBox(height: 2.h),
            _buildSliderSetting(
              title: "Hinglish-English Ratio",
              subtitle: "Balance between Hindi and English in responses",
              value: _hinglishRatio,
              onChanged: (value) => setState(() => _hinglishRatio = value),
              min: 0.0,
              max: 1.0,
            ),
            SizedBox(height: 2.h),
            _buildSwitchSetting(
              title: "Voice Feedback",
              subtitle: "Confirm actions with voice responses",
              value: _voiceFeedback,
              onChanged: (value) => setState(() => _voiceFeedback = value),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        // Personality Settings
        _buildSettingsSection(
          title: "Personality & Style",
          icon: "psychology",
          children: [
            _buildDropdownSetting(
              title: "Personality Mode",
              subtitle: "Choose MAAHI's interaction style",
              value: _selectedPersonality,
              items: personalities,
              onChanged: (value) =>
                  setState(() => _selectedPersonality = value!),
            ),
            SizedBox(height: 2.h),
            _buildDropdownSetting(
              title: "Voice Style",
              subtitle: "Select the tone for voice responses",
              value: _selectedVoiceStyle,
              items: voiceStyles,
              onChanged: (value) =>
                  setState(() => _selectedVoiceStyle = value!),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        // Advanced Settings
        _buildSettingsSection(
          title: "Advanced",
          icon: "tune",
          children: [
            _buildActionTile(
              title: "Voice Model Training",
              subtitle: "Improve recognition accuracy",
              icon: "model_training",
              onTap: () {
                // Navigate to voice training
              },
            ),
            SizedBox(height: 1.h),
            _buildActionTile(
              title: "Command History",
              subtitle: "Manage voice command logs",
              icon: "history",
              onTap: () {
                // Navigate to command history management
              },
            ),
            SizedBox(height: 1.h),
            _buildActionTile(
              title: "Privacy Settings",
              subtitle: "Control data collection and storage",
              icon: "privacy_tip",
              onTap: () {
                // Navigate to privacy settings
              },
            ),
            SizedBox(height: 1.h),
            _buildActionTile(
              title: "Reset Voice Settings",
              subtitle: "Restore default voice configurations",
              icon: "restore",
              isDestructive: true,
              onTap: () => _showResetDialog(),
            ),
          ],
        ),
        SizedBox(height: 10.h), // Extra space for FAB
      ],
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required String icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
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
                    child: CustomIconWidget(
                      iconName: icon,
                      color: AppTheme.primaryCyan,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  title,
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Divider(color: AppTheme.borderColor, height: 1),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting({
    required String title,
    required String subtitle,
    required double value,
    required ValueChanged<double> onChanged,
    required double min,
    required double max,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.darkTheme.textTheme.bodyLarge,
        ),
        SizedBox(height: 0.5.h),
        Text(
          subtitle,
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value,
                onChanged: onChanged,
                min: min,
                max: max,
                divisions: 10,
              ),
            ),
            SizedBox(width: 2.w),
            Container(
              width: 12.w,
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.deepCharcoal,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "${(value * 100).toInt()}%",
                style: AppTheme.dataTextStyle(
                  fontSize: 12,
                  color: AppTheme.primaryCyan,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSwitchSetting({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdownSetting({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.darkTheme.textTheme.bodyLarge,
        ),
        SizedBox(height: 0.5.h),
        Text(
          subtitle,
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            color: AppTheme.deepCharcoal,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            isExpanded: true,
            underline: SizedBox(),
            dropdownColor: AppTheme.elevatedSurface,
            style: AppTheme.darkTheme.textTheme.bodyMedium,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required String icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.deepCharcoal,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isDestructive ? AppTheme.errorRed : AppTheme.textSecondary,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: isDestructive
                          ? AppTheme.errorRed
                          : AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Reset Voice Settings"),
        content: Text(
          "This will restore all voice settings to their default values. This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: Text("Reset"),
          ),
        ],
      ),
    );
  }

  void _resetSettings() {
    setState(() {
      _wakeWordSensitivity = 0.7;
      _responseVerbosity = 0.8;
      _hinglishRatio = 0.6;
      _voiceOnlyNavigation = false;
      _offlineProcessing = true;
      _voiceFeedback = true;
      _selectedPersonality = "Desi Obedient";
      _selectedVoiceStyle = "Natural";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Voice settings have been reset to defaults"),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }
}
