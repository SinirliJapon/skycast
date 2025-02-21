import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skycast/providers/weather_provider.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _cityController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Skycast')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();

                await weatherProvider.fetchCitySuggestions(textEditingValue.text);
                return weatherProvider.citySuggestions;
              },
              onSelected: (String selection) => _cityController.text = selection,
              fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: (value) => weatherProvider.fetchCitySuggestions(value),
                  decoration: InputDecoration(
                    labelText: "Enter City Name",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        if (_cityController.text.isNotEmpty) {
                          context.read<WeatherProvider>().fetchWeatherByCity(_cityController.text);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                context.read<WeatherProvider>().fetchWeatherByLocation();
              },
              icon: const Icon(Icons.my_location),
              label: const Text("Use My Location"),
            ),
            const SizedBox(height: 20),
            Consumer<WeatherProvider>(
              builder: (context, weatherProvider, child) {
                if (weatherProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (weatherProvider.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(
                      weatherProvider.errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                if (weatherProvider.weather != null) {
                  final weather = weatherProvider.weather!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  );
                }

                return const Center(
                  child: Text(
                    "Enter a city name or use your location to get weather info",
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
