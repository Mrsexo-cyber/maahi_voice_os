import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PerformanceChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String metric;
  final bool isDetailed;

  const PerformanceChartWidget({
    Key? key,
    required this.data,
    required this.metric,
    this.isDetailed = false,
  }) : super(key: key);

  Color get _metricColor {
    switch (metric) {
      case 'cpu':
        return AppTheme.primaryCyan;
      case 'memory':
        return AppTheme.warningAmber;
      case 'battery':
        return AppTheme.successGreen;
      case 'temperature':
        return AppTheme.errorRed;
      case 'network':
        return AppTheme.tealAccent;
      default:
        return AppTheme.primaryCyan;
    }
  }

  String get _metricUnit {
    switch (metric) {
      case 'cpu':
      case 'memory':
      case 'battery':
        return '%';
      case 'temperature':
        return '°C';
      case 'network':
        return 'Mbps';
      default:
        return '';
    }
  }

  double get _maxY {
    switch (metric) {
      case 'cpu':
      case 'memory':
      case 'battery':
        return 100;
      case 'temperature':
        return 60;
      case 'network':
        return 60;
      default:
        return 100;
    }
  }

  List<FlSpot> get _chartData {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final value = (item[metric] as num).toDouble();
      return FlSpot(index.toDouble(), value);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: isDetailed ? 40.h : 25.h,
      child: Semantics(
        label: "${metric.toUpperCase()} Performance Chart",
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              drawHorizontalLine: true,
              horizontalInterval: _maxY / 5,
              verticalInterval: data.length / 4,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: AppTheme.borderColor.withValues(alpha: 0.3),
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: AppTheme.borderColor.withValues(alpha: 0.3),
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: data.length / 4,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < data.length) {
                      final timestamp =
                          data[value.toInt()]["timestamp"] as DateTime;
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}',
                          style:
                              AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: _maxY / 5,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        '${value.toInt()}$_metricUnit',
                        style:
                            AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: AppTheme.borderColor.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            minX: 0,
            maxX: (data.length - 1).toDouble(),
            minY: 0,
            maxY: _maxY,
            lineBarsData: [
              LineChartBarData(
                spots: _chartData,
                isCurved: true,
                gradient: LinearGradient(
                  colors: [
                    _metricColor,
                    _metricColor.withValues(alpha: 0.7),
                  ],
                ),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: isDetailed,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: _metricColor,
                      strokeWidth: 2,
                      strokeColor: AppTheme.elevatedSurface,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      _metricColor.withValues(alpha: 0.3),
                      _metricColor.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: AppTheme.elevatedSurface,
                tooltipRoundedRadius: 8,
                tooltipPadding: EdgeInsets.all(2.w),
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  return touchedBarSpots.map((barSpot) {
                    final timestamp =
                        data[barSpot.x.toInt()]["timestamp"] as DateTime;
                    return LineTooltipItem(
                      '${barSpot.y.toStringAsFixed(1)}$_metricUnit\n${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}',
                      AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: _metricColor,
                          ) ??
                          const TextStyle(),
                    );
                  }).toList();
                },
              ),
              handleBuiltInTouches: true,
              getTouchedSpotIndicator:
                  (LineChartBarData barData, List<int> spotIndexes) {
                return spotIndexes.map((spotIndex) {
                  return TouchedSpotIndicatorData(
                    FlLine(
                      color: _metricColor.withValues(alpha: 0.5),
                      strokeWidth: 2,
                      dashArray: [5, 5],
                    ),
                    FlDotData(
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 6,
                          color: _metricColor,
                          strokeWidth: 3,
                          strokeColor: AppTheme.elevatedSurface,
                        );
                      },
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
