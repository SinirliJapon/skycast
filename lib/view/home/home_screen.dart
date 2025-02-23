import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skycast/core/constants/app_strings.dart';
import 'package:skycast/core/utils.dart';
import 'package:skycast/providers/weather_provider.dart';
import 'package:skycast/providers/weather_units_provider.dart';
import 'package:skycast/widgets/custom_drawer.dart';
import 'package:skycast/widgets/custom_forecast_chart.dart';
import 'package:skycast/widgets/custom_forecast_info_column.dart';
import 'package:skycast/widgets/custom_list_tile.dart';
import 'package:skycast/widgets/custom_text_field.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  final TextEditingController _cityController = TextEditingController();
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherUnitsProvider = Provider.of<WeatherUnitsProvider>(context);
    String unit = weatherUnitsProvider.unit;
    return Scaffold(
      appBar: AppBar(title: CustomTextField(cityController: _cityController), actions: [LocationButton()]),
      drawer: CustomDrawer(),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (weatherProvider.errorMessage.isNotEmpty) {
            return Center(child: Text(weatherProvider.errorMessage));
          } else if (weatherProvider.weather != null) {
            final weather = weatherProvider.weather!;
            final weeklyForecast = weatherProvider.weeklyForecast;
            final description = Utils.capitalizeFirstLetter(weather.description);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(weather.weatherIcon, height: 100, width: 100),
                  Text(description, style: const TextStyle(fontSize: 22)),
                  Text(weather.cityName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Divider(height: 10),
                  CustomForecastInfoColumn(weather: weather, unit: unit),
                  Divider(height: 10),
                  CustomListTile(title: "7-Day Forecast", icon: Icons.calendar_view_week),
                  CustomForecastChart(forecastList: weeklyForecast),
                ],
              ),
            );
          } else {
            return Center(child: Text(AppStrings.entryMessage));
          }
        },
      ),
    );
  }
}

class LocationButton extends StatelessWidget {
  const LocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherUnitsProvider = Provider.of<WeatherUnitsProvider>(context);
    String unit = weatherUnitsProvider.unit;

    return IconButton(
      icon: Icon(Icons.pin_drop),
      onPressed: () => context.read<WeatherProvider>().fetchWeatherByLocation(unit),
    );
  }
}
