import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skycast/core/constants/app_strings.dart';
import 'package:skycast/providers/weather_provider.dart';
import 'package:skycast/providers/weather_units_provider.dart';

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
