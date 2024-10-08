import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/route/router.dart' as router;
import 'package:shop/theme/app_theme.dart';

void main() async {
  // Ensure Flutter is initialized properly before calling async functions
  WidgetsFlutterBinding.ensureInitialized();

  // Get the initial route based on user login state
  String initialRoute = await getInitialRoute() ?? onbordingScreenRoute;

  runApp(MyApp(initialRoute: initialRoute));
}

// Function to determine the initial route
Future<String?> getInitialRoute() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the user is logged in by checking for a stored token
    String? token = prefs.getString('token');

    // If token exists, return entry point screen route, otherwise return onboarding
    if (token != null && token.isNotEmpty) {
      return entryPointScreenRoute;
    } else {
      return onbordingScreenRoute; // Default to onboarding or login
    }
  } catch (e) {
    // Handle error case (for instance, if SharedPreferences fails to load)
    print("Error getting initial route: $e");
    return onbordingScreenRoute; // Provide a fallback route
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Template by The Flutter Way',
      theme: AppTheme.lightTheme(context),
      themeMode: ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      initialRoute:
          initialRoute, // Set the initial route based on the login state
    );
  }
}
