import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skycast/core/constants/app_strings.dart';
import 'package:skycast/core/router/app_router.gr.dart';
import 'package:skycast/providers/weather_provider.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  final TextEditingController _cityController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(weather.cityName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(weather.description, style: const TextStyle(fontSize: 22)),
                  Text("Temperature: ${weather.temperature}°C", style: const TextStyle(fontSize: 22)),
                  Text("Feels Like: ${weather.feelsLike}°C", style: const TextStyle(fontSize: 22)),
                  Text("Min Temperature: ${weather.tempMin}°C", style: const TextStyle(fontSize: 22)),
                  Text("Max Temperature: ${weather.tempMax}°C", style: const TextStyle(fontSize: 22)),
                  Text("Wind Speed: ${weather.windSpeed} km/h", style: const TextStyle(fontSize: 22)),
                  Text("Humidity: ${weather.humidity}%", style: const TextStyle(fontSize: 22)),
                  Text("Pressure: ${weather.pressure} hPa", style: const TextStyle(fontSize: 22)),
                  Text("Cloudiness: ${weather.cloudiness}%", style: const TextStyle(fontSize: 22)),
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
    return IconButton(
      icon: Icon(Icons.pin_drop),
      onPressed: () => context.read<WeatherProvider>().fetchWeatherByLocation(),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.cityController});

  final TextEditingController cityController;

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Autocomplete<String>(
        onSelected: (String selection) {
          cityController.text = selection;
          weatherProvider.fetchWeatherByCity(selection);
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
                    weatherProvider.fetchWeatherByCity(controller.text);
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
