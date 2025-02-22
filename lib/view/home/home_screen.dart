import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skycast/core/constants/app_strings.dart';
import 'package:skycast/core/router/app_router.gr.dart';
import 'package:skycast/core/utils.dart';
import 'package:skycast/providers/weather_provider.dart';
import 'package:skycast/providers/weather_units_provider.dart';

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
            String temperatureUnit = Utils.getUnitSymbol(unit);
            String windSpeedUnit = Utils.getWindSpeedUnit(unit);
            String temperature = "Temperature: ${weather.temperature}$temperatureUnit";
            String feelsLike = "Feels Like: ${weather.feelsLike}$temperatureUnit";
            String tempMin = "Min Temperature: ${weather.tempMin}$temperatureUnit";
            String tempMax = "Max Temperature: ${weather.tempMax}$temperatureUnit";
            String windSpeed = "Wind Speed: ${weather.windSpeed} $windSpeedUnit";
            String humidity = "Humidity: ${weather.humidity}%";
            String pressure = "Pressure: ${weather.pressure} hPa";
            String cloudiness = "Cloudiness: ${weather.cloudiness}%";
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(weather.weatherIcon, height: 100, width: 100),
                  Text(weather.cityName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(weather.description, style: const TextStyle(fontSize: 22)),
                  Text(temperature, style: const TextStyle(fontSize: 22)),
                  Text(feelsLike, style: const TextStyle(fontSize: 22)),
                  Text(tempMin, style: const TextStyle(fontSize: 22)),
                  Text(tempMax, style: const TextStyle(fontSize: 22)),
                  Text(windSpeed, style: const TextStyle(fontSize: 22)),
                  Text(humidity, style: const TextStyle(fontSize: 22)),
                  Text(pressure, style: const TextStyle(fontSize: 22)),
                  Text(cloudiness, style: const TextStyle(fontSize: 22)),
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

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text(AppStrings.appName)),
          DrawerListTile(title: 'Favorites', icon: Icons.star, onTap: () => context.router.push(FavoritesRoute())),
          DrawerListTile(title: 'Settings', icon: Icons.settings, onTap: () => context.router.push(SettingsRoute())),
          DrawerListTile(title: 'About', icon: Icons.info, onTap: () {}),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;

  const DrawerListTile({super.key, required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(title), leading: Icon(icon), onTap: onTap);
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

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.cityController});

  final TextEditingController cityController;

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    final weatherUnitsProvider = Provider.of<WeatherUnitsProvider>(context);
    String unit = weatherUnitsProvider.unit;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Autocomplete<String>(
        onSelected: (String selection) {
          cityController.text = selection;
          weatherProvider.fetchWeatherByCity(selection, unit);
        },
        optionsBuilder: (TextEditingValue textEditingValue) async {
          if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
          await weatherProvider.fetchCitySuggestions(textEditingValue.text);
          return weatherProvider.citySuggestions;
        },
        fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
          return TextField(
            controller: controller,
            focusNode: focusNode,
            enableSuggestions: false,
            onChanged: (value) => weatherProvider.fetchCitySuggestions(value),
            decoration: InputDecoration(
              hintText: AppStrings.searchHint,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (controller.text.isNotEmpty) {
                    weatherProvider.fetchWeatherByCity(controller.text, unit);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
