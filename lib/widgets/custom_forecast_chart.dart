import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomForecastChart extends StatelessWidget {
  const CustomForecastChart({super.key, required this.forecastList});

  final List<dynamic> forecastList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: forecastList.length * 70,
      padding: const EdgeInsets.all(30),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: forecastList.length.toDouble() - 1,
          minY: forecastList.map((e) => e.temperatureDay).reduce((a, b) => a < b ? a : b) - 2,
          maxY: forecastList.map((e) => e.temperatureDay).reduce((a, b) => a > b ? a : b) + 2,
          titlesData: _buildChartTitles(forecastList),
          lineBarsData: [_buildLineChartBarsData(forecastList)],
          lineTouchData: _buildLineTouchData(forecastList),
        ),
      ),
    );
  }

  LineTouchData _buildLineTouchData(List<dynamic> weeklyForecast) {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((spot) {
            return LineTooltipItem(
              "${weeklyForecast[spot.x.toInt()].temperatureDay}°",
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            );
          }).toList();
        },
      ),
    );
  }

  LineChartBarData _buildLineChartBarsData(List<dynamic> weeklyForecast) {
    return LineChartBarData(
      isCurved: true,
      barWidth: 3,
      color: Colors.orangeAccent,
      aboveBarData: BarAreaData(show: false),
      belowBarData: BarAreaData(show: false),
      spots:
          weeklyForecast.asMap().entries.map((entry) {
            return FlSpot(entry.key.toDouble(), entry.value.temperatureDay);
          }).toList(),
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(radius: 5, strokeWidth: 2, color: Colors.orange, strokeColor: Colors.white);
        },
      ),
    );
  }

  FlTitlesData _buildChartTitles(List<dynamic> weeklyForecast) {
    return FlTitlesData(
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            int index = value.toInt();
            return index < weeklyForecast.length
                ? Image.network(weeklyForecast[index].weatherIconUrl, width: 30, height: 30)
                : SizedBox();
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            int index = value.toInt();
            return index < weeklyForecast.length
                ? Text(weeklyForecast[index].formattedDate, style: const TextStyle(fontSize: 12))
                : SizedBox();
          },
        ),
      ),
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
