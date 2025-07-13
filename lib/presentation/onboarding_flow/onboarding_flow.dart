import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';
import './widgets/personality_mode_card_widget.dart';
import './widgets/voice_waveform_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _waveformController;
  late AnimationController _fadeController;
  int _currentPage = 0;
  bool _isListening = false;
  String _selectedPersonality = 'Desi Obedient';

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "id": 1,
      "title": "Hey MAAHI!",
      "subtitle": "Wake me up with your voice",
      "description":
          "Simply say 'Hey MAAHI' to activate your intelligent voice assistant. I'll be ready to help you control your device hands-free.",
      "image":
          "https://images.unsplash.com/photo-1589254065878-42c9da997008?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "primaryAction": "Try Wake Word",
      "features": [
        "Offline wake word detection",
        "Always listening mode",
        "Voice activation training"
      ]
    },
    {
      "id": 2,
      "title": "Hinglish Commands",
      "subtitle": "Speak naturally, get results",
      "description":
          "Use natural Hinglish commands like 'brightness badha do' or 'WiFi on kar do'. I understand how you naturally speak.",
      "image":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "primaryAction": "Try Commands",
      "features": [
        "Natural language processing",
        "Hindi-English mix support",
        "Real-time system control"
      ]
    },
    {
      "id": 3,
      "title": "Choose Your MAAHI",
      "subtitle": "Pick your perfect personality",
      "description":
          "Select how MAAHI should interact with you. From obedient assistant to romantic companion - choose your style.",
      "image":
          "https://images.unsplash.com/photo-1535378917042-10a22c95931a?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "primaryAction": "Select Personality",
      "features": [
        "4 unique personalities",
        "Customizable responses",
        "Emotional intelligence"
      ]
    }
  ];

  final List<Map<String, dynamic>> _personalityModes = [
    {
      "id": 1,
      "name": "Desi Obedient",
      "description": "Respectful and helpful assistant",
      "sample": "Ji Boss, brightness badha diya hai",
      "color": AppTheme.primaryCyan,
      "icon": "person"
    },
    {
      "id": 2,
      "name": "Waifu Romantic",
      "description": "Sweet and caring companion",
      "sample": "Darling, aapka brightness perfect kar diya",
      "color": AppTheme.warningAmber,
      "icon": "favorite"
    },
    {
      "id": 3,
      "name": "Hacker Sharp",
      "description": "Technical and precise responses",
      "sample": "System brightness level increased to 80%",
      "color": AppTheme.successGreen,
      "icon": "code"
    },
    {
      "id": 4,
      "name": "Sassy Desi",
      "description": "Witty and playful attitude",
      "sample": "Haan haan, brightness badha diya, khush?",
      "color": AppTheme.tealAccent,
      "icon": "mood"
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _waveformController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _waveformController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/permission-setup-wizard');
  }

  void _completeOnboarding() {
    Navigator.pushReplacementNamed(context, '/permission-setup-wizard');
  }

  void _tryWakeWord() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      _waveformController.repeat();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Say "Hey MAAHI" to test wake word detection',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          backgroundColor: AppTheme.elevatedSurface,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      _waveformController.stop();
    }
  }

  void _tryCommand() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Try saying: "brightness badha do" or "WiFi on kar do"',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        backgroundColor: AppTheme.elevatedSurface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _selectPersonality(String personality) {
    setState(() {
      _selectedPersonality = personality;
    });

    final selectedMode = _personalityModes.firstWhere(
      (mode) => mode['name'] == personality,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected: ${selectedMode['name']} - "${selectedMode['sample']}"',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        backgroundColor: AppTheme.elevatedSurface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildActionButton(Map<String, dynamic> pageData) {
    switch (_currentPage) {
      case 0:
        return ElevatedButton.icon(
          onPressed: _tryWakeWord,
          icon: CustomIconWidget(
            iconName: _isListening ? 'mic' : 'mic_none',
            color: AppTheme.trueDarkBackground,
            size: 20,
          ),
          label:
              Text(_isListening ? 'Stop Listening' : pageData['primaryAction']),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _isListening ? AppTheme.errorRed : AppTheme.primaryCyan,
            foregroundColor: AppTheme.trueDarkBackground,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          ),
        );
      case 1:
        return ElevatedButton.icon(
          onPressed: _tryCommand,
          icon: CustomIconWidget(
            iconName: 'record_voice_over',
            color: AppTheme.trueDarkBackground,
            size: 20,
          ),
          label: Text(pageData['primaryAction']),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          ),
        );
      case 2:
        return ElevatedButton.icon(
          onPressed: () => _selectPersonality(_selectedPersonality),
          icon: CustomIconWidget(
            iconName: 'psychology',
            color: AppTheme.trueDarkBackground,
            size: 20,
          ),
          label: Text(pageData['primaryAction']),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.trueDarkBackground,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeController,
          child: Column(
            children: [
              // Top Navigation Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        'Skip',
                        style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    PageIndicatorWidget(
                      currentPage: _currentPage,
                      totalPages: _onboardingData.length,
                    ),
                    SizedBox(width: 15.w), // Balance the skip button
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                      _isListening = false;
                    });
                    _waveformController.stop();
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    final pageData = _onboardingData[index];
                    return OnboardingPageWidget(
                      title: pageData['title'],
                      subtitle: pageData['subtitle'],
                      description: pageData['description'],
                      imageUrl: pageData['image'],
                      features: (pageData['features'] as List).cast<String>(),
                      customContent: _buildCustomContent(index),
                    );
                  },
                ),
              ),

              // Bottom Action Area
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                child: Column(
                  children: [
                    _buildActionButton(_onboardingData[_currentPage]),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentPage > 0)
                          TextButton.icon(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            icon: CustomIconWidget(
                              iconName: 'arrow_back',
                              color: AppTheme.textSecondary,
                              size: 20,
                            ),
                            label: Text(
                              'Previous',
                              style: AppTheme.darkTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        ElevatedButton.icon(
                          onPressed: _nextPage,
                          icon: CustomIconWidget(
                            iconName: _currentPage == _onboardingData.length - 1
                                ? 'check'
                                : 'arrow_forward',
                            color: AppTheme.trueDarkBackground,
                            size: 20,
                          ),
                          label: Text(
                            _currentPage == _onboardingData.length - 1
                                ? 'Get Started'
                                : 'Next',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryCyan,
                            foregroundColor: AppTheme.trueDarkBackground,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 2.h),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomContent(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return Column(
          children: [
            SizedBox(height: 2.h),
            if (_isListening)
              VoiceWaveformWidget(
                controller: _waveformController,
                isActive: _isListening,
              ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.elevatedSurface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.borderColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.primaryCyan,
                    size: 24,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Why we need microphone access?',
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.primaryCyan,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'MAAHI needs microphone access to detect the wake word "Hey MAAHI" and process your voice commands. All processing happens offline for privacy.',
                    style: AppTheme.darkTheme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.elevatedSurface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.borderColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Example Commands:',
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.primaryCyan,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ...[
                    '"brightness badha do"',
                    '"WiFi on kar do"',
                    '"volume kam kar"',
                    '"screenshot le lo"'
                  ]
                      .map((command) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.5.h),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'mic',
                                  color: AppTheme.tealAccent,
                                  size: 16,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  command,
                                  style: AppTheme.darkTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            SizedBox(height: 2.h),
            Text(
              'Choose Your Personality:',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryCyan,
              ),
            ),
            SizedBox(height: 2.h),
            ...(_personalityModes).map((mode) {
              final isSelected = _selectedPersonality == mode['name'];
              return PersonalityModeCardWidget(
                name: mode['name'],
                description: mode['description'],
                sample: mode['sample'],
                color: mode['color'],
                iconName: mode['icon'],
                isSelected: isSelected,
                onTap: () => _selectPersonality(mode['name']),
              );
            }).toList(),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
