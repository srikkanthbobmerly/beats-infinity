import 'package:beats_infinity/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'theme.dart';
import 'screens/onboarding_screen.dart';
import 'seasonal_mood.dart';

void main() {
  runApp(const SeasonalBeatsInfinityApp());
}

class BeatsInfinityApp extends StatelessWidget {
  const BeatsInfinityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Beats Infinity',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const OnboardingScreen(),
      ),
    );
  }
}
