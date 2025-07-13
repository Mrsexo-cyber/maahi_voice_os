import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './active_routines_widget.dart';
import './quick_actions_widget.dart';
import './recent_commands_widget.dart';
import './system_metrics_widget.dart';
import './voice_waveform_widget.dart';

class ExpandedDashboardWidget extends StatefulWidget {
  final Map<String, dynamic> systemData;
  final List<Map<String, dynamic>> quickActions;
  final List<Map<String, dynamic>> recentCommands;
  final List<Map<String, dynamic>> activeRoutines;
  final VoidCallback onCollapse;
  final bool isListening;
  final AnimationController waveformController;

  const ExpandedDashboardWidget({
    Key? key,
    required this.systemData,
    required this.quickActions,
    required this.recentCommands,
    required this.activeRoutines,
    required this.onCollapse,
    required this.isListening,
    required this.waveformController,
  }) : super(key: key);

  @override
  State<ExpandedDashboardWidget> createState() =>
      _ExpandedDashboardWidgetState();
}

class _ExpandedDashboardWidgetState extends State<ExpandedDashboardWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.trueDarkBackground.withValues(alpha: 0.95),
            AppTheme.deepCharcoal.withValues(alpha: 0.98),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header with collapse button
            _buildHeader(),

            // Voice status indicator
            if (widget.isListening)
              Container(
                width: 100.w,
                height: 8.h,
                child: VoiceWaveformWidget(
                  controller: widget.waveformController,
                  isCompact: false,
                ),
              ),

            // Tab navigation
            _buildTabBar(),

            // Content sections
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewSection(),
                  _buildQuickActionsSection(),
                  _buildCommandsSection(),
                  _buildRoutinesSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          // MAAHI Avatar
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryCyan.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6.w),
              border: Border.all(
                color: widget.isListening
                    ? AppTheme.primaryCyan
                    : AppTheme.borderColor,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                'M',
                style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.primaryCyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(width: 4.w),

          // Status info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MAAHI Voice OS',
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryCyan,
                  ),
                ),
                Text(
                  widget.isListening
                      ? 'Listening...'
                      : 'Ready - Say "Hey MAAHI"',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Collapse button
          IconButton(
            onPressed: widget.onCollapse,
            icon: CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.primaryCyan,
              size: 6.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.primaryCyan.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        labelColor: AppTheme.primaryCyan,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: AppTheme.darkTheme.textTheme.labelMedium,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Actions'),
          Tab(text: 'Commands'),
          Tab(text: 'Routines'),
        ],
      ),
    );
  }

  Widget _buildOverviewSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          SystemMetricsWidget(systemData: widget.systemData),
          SizedBox(height: 3.h),
          _buildQuickStatsCard(),
          SizedBox(height: 3.h),
          _buildPersonalityCard(),
        ],
      ),
    );
  }

  Widget _buildQuickStatsCard() {
    return Container(
      width: 100.w,
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassmorphismDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Stats',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryCyan,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Active Apps',
                  '${widget.systemData["activeApps"]}',
                  'apps',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Storage Used',
                  '${widget.systemData["storageUsed"]}%',
                  'storage',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String icon) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.tealAccent,
          size: 6.w,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.dataTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryCyan,
          ),
        ),
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildPersonalityCard() {
    return Container(
      width: 100.w,
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassmorphismDecoration,
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'person',
            color: AppTheme.primaryCyan,
            size: 8.w,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Personality',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  widget.systemData["personality"] as String,
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryCyan,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // Show personality selection
            },
            child: Text('Switch'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: QuickActionsWidget(actions: widget.quickActions),
    );
  }

  Widget _buildCommandsSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: RecentCommandsWidget(commands: widget.recentCommands),
    );
  }

  Widget _buildRoutinesSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: ActiveRoutinesWidget(routines: widget.activeRoutines),
    );
  }
}
