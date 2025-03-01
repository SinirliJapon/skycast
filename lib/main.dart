import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:skycast/core/router/app_router.dart';
import 'package:skycast/providers/theme_provider.dart';
import 'package:skycast/providers/weather_provider.dart';
import 'package:skycast/providers/weather_units_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => WeatherUnitsProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          themeMode: themeProvider.themeMode,
          theme: themeProvider.lightTheme, 
          darkTheme: themeProvider.darkTheme,
          routerConfig: _appRouter.config(),
        );
      },
    );
  }
}
