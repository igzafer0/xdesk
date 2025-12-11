import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:design_system/design_system.dart';
import 'package:fl_chart/fl_chart.dart';
import '../stores/currency_chart_store_base.dart';
import 'chart_common_widgets.dart';
import '../../domain/entities/currency_chart.dart';
import '../../domain/entities/currency_chart_point.dart';

/// Generic Currency Chart Widget
/// 
/// Tüm currency chart'ları için ortak widget.
/// Store'ları CurrencyChartStoreBase interface'i üzerinden kullanır.
class CurrencyChartWidget extends StatelessWidget {
  final CurrencyChartStoreBase store;

  const CurrencyChartWidget({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (store.errorMessage != null && store.chart == null) {
          return ChartErrorWidget(
            message: store.errorMessage!,
            onRetry: () => store.loadChart(),
          );
        }

        final last24HoursChart = store.last24HoursChart;
        if (last24HoursChart == null || last24HoursChart.points.isEmpty) {
          return const SizedBox.shrink();
        }
        return _ChartContent(chart: last24HoursChart);
      },
    );
  }
}

class _ChartContent extends StatefulWidget {
  final CurrencyChart chart;

  const _ChartContent({required this.chart});

  @override
  State<_ChartContent> createState() => _ChartContentState();
}

class _ChartContentState extends State<_ChartContent> {
  late final List<CurrencyChartPoint> _points;
  late final double _minValue;
  late final double _maxValue;
  late final List<FlSpot> _spotData;

  @override
  void initState() {
    super.initState();
    _calculateChartData();
  }

  @override
  void didUpdateWidget(_ChartContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chart != widget.chart) {
      _calculateChartData();
    }
  }

  void _calculateChartData() {
    _points = widget.chart.points;
    
    if (_points.isEmpty) {
      _minValue = 0.0;
      _maxValue = 0.0;
      _spotData = [];
      return;
    }
    
    double min = double.infinity;
    double max = double.negativeInfinity;
    _spotData = List.generate(_points.length, (index) {
      final value = _points[index].value;
      if (value < min) min = value;
      if (value > max) max = value;
      return FlSpot(index.toDouble(), value);
    });
    
    _minValue = min;
    _maxValue = max;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: (_maxValue - _minValue) / 4,
              getDrawingHorizontalLine: (value) {
                return FlLine(color: AppColors.borderPrimary, strokeWidth: 1);
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
                  reservedSize: 40,
                  interval: (_points.length - 1) / 4,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < _points.length) {
                      final originalString = _points[index].originalCreatedAt;
                      final timePart = originalString.split('T')[1];
                      final hourMinute = timePart.substring(0, 5);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          hourMinute,
                          style: AppTypography.labelSmall,
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  interval: (_maxValue - _minValue) / 4,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toStringAsFixed(2),
                      style: AppTypography.labelSmall,
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: AppColors.borderPrimary),
            ),
            minX: 0,
            maxX: (_points.length - 1).toDouble(),
            minY: _minValue - (_maxValue - _minValue) * 0.1,
            maxY: _maxValue + (_maxValue - _minValue) * 0.1,
            lineBarsData: [
              LineChartBarData(
                spots: _spotData,
                isCurved: true,
                color: AppColors.textPrimary,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.textPrimary.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

