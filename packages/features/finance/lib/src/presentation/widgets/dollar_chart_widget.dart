import 'package:finance/finance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:design_system/design_system.dart';
import 'package:fl_chart/fl_chart.dart';

/// Dollar Chart Widget
///
/// Dolar chart'ını gösterir
class DollarChartWidget extends StatelessWidget {
  final DollarChartStore store;

  const DollarChartWidget({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (store.isLoading && store.chart == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (store.errorMessage != null && store.chart == null) {
          return ChartErrorWidget(
            message: store.errorMessage!,
            onRetry: () => store.loadChart(),
          );
        }

        if (store.chart == null || store.chart!.points.isEmpty) {
          return const Center(
            child: Text('Veri bulunamadı', style: AppTypography.bodyMedium),
          );
        }

        // Son 24 saatlik verileri göster
        final last24HoursChart = store.chart!.last24Hours();
        return _ChartContent(chart: last24HoursChart);
      },
    );
  }
}

/// Chart içeriği
class _ChartContent extends StatelessWidget {
  final CurrencyChart chart;

  const _ChartContent({required this.chart});

  @override
  Widget build(BuildContext context) {
    final points = chart.points;
    final minValue = points.map((p) => p.value).reduce((a, b) => a < b ? a : b);
    final maxValue = points.map((p) => p.value).reduce((a, b) => a > b ? a : b);

    // fl_chart için spot data oluştur
    final spotData = points
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
        .toList();

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
              horizontalInterval: (maxValue - minValue) / 4,
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
                  interval: (points.length - 1) / 4, // 4-5 tarih göster
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < points.length) {
                      // API'den gelen orijinal string'den saat bilgisini al
                      final originalString = points[index].originalCreatedAt;
                      // Format: "2025-12-10T16:32:22.956851+03:00"
                      // T'den sonraki kısmı al (16:32:22.956851+03:00)
                      final timePart = originalString.split('T')[1];
                      // İlk 5 karakteri al (HH:mm)
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
                  interval: (maxValue - minValue) / 4,
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
            maxX: (points.length - 1).toDouble(),
            minY: minValue - (maxValue - minValue) * 0.1,
            maxY: maxValue + (maxValue - minValue) * 0.1,
            lineBarsData: [
              LineChartBarData(
                spots: spotData,
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
