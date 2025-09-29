import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const WeeklyBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox(
        height: 150,
        child: Center(child: Text('No data for week')),
      );
    }

    final groups = <BarChartGroupData>[];
    int maxSteps = 1;

    for (int i = 0; i < data.length; i++) {
      final steps = data[i]['steps'] as int;
      if (steps > maxSteps) maxSteps = steps;

      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: steps.toDouble(),
              width: 18,
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4),
            )
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BarChart(
            BarChartData(
              maxY: (maxSteps * 1.2).toDouble(),
              barGroups: groups,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipRoundedRadius: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final dayLabel = DateFormat.E().format(data[group.x.toInt()]['date'] as DateTime);
                    return BarTooltipItem(
                      '$dayLabel\n${rod.toY.toInt()} steps',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
                      final date = data[idx]['date'] as DateTime;
                      return Text(DateFormat.E().format(date));
                    },
                  ),
                ),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ),
    );
  }
}
