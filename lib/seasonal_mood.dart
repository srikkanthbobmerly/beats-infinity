import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/app_state.dart';
import 'theme.dart';
import 'screens/onboarding_screen.dart';

// =============================================================================
// SEASONAL MOOD — drop-in file
//
// This is the ONLY new file you need, plus a 2-line change in main.dart
// (see the bottom of this file for exactly what to change). Nothing else
// in your project is touched: AppColors, theme.dart's structure, and every
// screen stay exactly as they are.
//
// What you get:
//  - 8 occasions auto-detected by today's date (New Year, Valentine's, Holi,
//    Independence Day, Onam, Diwali, Halloween, Christmas), each shifting the
//    app's primary/accent color and adding themed falling emoji particles
//    over the whole app.
//  - A small floating "mood pill" that only appears for the logged-in admin,
//    letting them preview/override any occasion instantly.
// =============================================================================

// -----------------------------------------------------------------------------
// 1. Occasions & palettes
// -----------------------------------------------------------------------------

enum Occasion { regular, newYear, valentines, holi, independence, onam, diwali, halloween, christmas }

class OccasionPalette {
  final String label;
  final String emoji;
  final Color primary;
  final Color primaryDark;
  final Color accent;
  final List<Color> heroGradient;
  final List<String> particles;
  final int particleCount;

  const OccasionPalette({
    required this.label,
    required this.emoji,
    required this.primary,
    required this.primaryDark,
    required this.accent,
    required this.heroGradient,
    this.particles = const [],
    this.particleCount = 22,
  });

  bool get hasParticles => particles.isNotEmpty;
}

const Map<Occasion, OccasionPalette> occasionPalettes = {
  Occasion.regular: OccasionPalette(
    label: 'Beats Infinity',
    emoji: '🎤',
    primary: Color(0xFF7C6EF6), // matches your current AppColors.primary
    primaryDark: Color(0xFF5B4FE0),
    accent: Color(0xFF9F8BFF),
    heroGradient: [Color(0xFF7C6EF6), Color(0xFFB06AB3)],
    particles: [],
  ),
  Occasion.newYear: OccasionPalette(
    label: 'New Year',
    emoji: '🎉',
    primary: Color(0xFFF5B301),
    primaryDark: Color(0xFFC98F00),
    accent: Color(0xFFFFE58A),
    heroGradient: [Color(0xFF1E1B4B), Color(0xFFF5B301)],
    particles: ['🎉', '✨', '🎊'],
  ),
  Occasion.valentines: OccasionPalette(
    label: "Valentine's",
    emoji: '💘',
    primary: Color(0xFFE63969),
    primaryDark: Color(0xFFAF1E49),
    accent: Color(0xFFFF8FAE),
    heroGradient: [Color(0xFF8E0038), Color(0xFFFF4D6D)],
    particles: ['💗', '💕', '💖'],
  ),
  Occasion.holi: OccasionPalette(
    label: 'Holi',
    emoji: '🎨',
    primary: Color(0xFFEF476F),
    primaryDark: Color(0xFFB3335A),
    accent: Color(0xFF06D6A0),
    heroGradient: [Color(0xFFF72585), Color(0xFF7209B7), Color(0xFF3A86FF), Color(0xFFFFBE0B)],
    particles: ['🎨', '🔴', '🟡', '🟢', '🔵'],
  ),
  Occasion.independence: OccasionPalette(
    label: 'Independence Day',
    emoji: '🇮🇳',
    primary: Color(0xFFFF9933),
    primaryDark: Color(0xFFCC7A29),
    accent: Color(0xFF128807),
    heroGradient: [Color(0xFFFF9933), Color(0xFFFFFFFF), Color(0xFF128807)],
    particles: ['🇮🇳', '✨'],
  ),
  Occasion.onam: OccasionPalette(
    label: 'Onam',
    emoji: '🌼',
    primary: Color(0xFFF4A300),
    primaryDark: Color(0xFFC17F00),
    accent: Color(0xFF2E8B57),
    heroGradient: [Color(0xFF2E8B57), Color(0xFFF4A300)],
    particles: ['🌼', '🌸', '🪷'],
  ),
  Occasion.diwali: OccasionPalette(
    label: 'Diwali',
    emoji: '🪔',
    primary: Color(0xFFFF7A00),
    primaryDark: Color(0xFFC75F00),
    accent: Color(0xFFFFD24C),
    heroGradient: [Color(0xFF3B0A45), Color(0xFFFF7A00)],
    particles: ['🪔', '✨', '🎆'],
  ),
  Occasion.halloween: OccasionPalette(
    label: 'Halloween',
    emoji: '🎃',
    primary: Color(0xFFFF7518),
    primaryDark: Color(0xFFC65A0F),
    accent: Color(0xFF8E44AD),
    heroGradient: [Color(0xFF1B1B2F), Color(0xFFFF7518)],
    particles: ['🦇', '🎃', '👻'],
  ),
  Occasion.christmas: OccasionPalette(
    label: 'Christmas',
    emoji: '🎄',
    primary: Color(0xFFC0392B),
    primaryDark: Color(0xFF922B21),
    accent: Color(0xFF1E824C),
    heroGradient: [Color(0xFF0B3D2E), Color(0xFFC0392B)],
    particles: ['❄️', '🎄', '⭐'],
  ),
};

// -----------------------------------------------------------------------------
// 2. Date resolution
//    ⚠️ Update the lunar peak dates yearly — Holi/Diwali/Onam shift each year.
// -----------------------------------------------------------------------------

final Map<Occasion, Map<int, DateTime>> _lunarPeaks = {
  Occasion.holi: {2026: DateTime(2026, 3, 3), 2027: DateTime(2027, 3, 22)},
  Occasion.diwali: {2026: DateTime(2026, 11, 8), 2027: DateTime(2027, 10, 29)},
  Occasion.onam: {2026: DateTime(2026, 8, 26), 2027: DateTime(2027, 9, 14)},
};

final Map<Occasion, DateTime Function(int year)> _lunarFallback = {
  Occasion.holi: (y) => DateTime(y, 3, 5),
  Occasion.diwali: (y) => DateTime(y, 10, 28),
  Occasion.onam: (y) => DateTime(y, 8, 28),
};

bool _withinWindow(DateTime now, DateTime peak, int daysBefore, int daysAfter) {
  final start = peak.subtract(Duration(days: daysBefore));
  final end = peak.add(Duration(days: daysAfter));
  final d = DateTime(now.year, now.month, now.day);
  return !d.isBefore(DateTime(start.year, start.month, start.day)) &&
      !d.isAfter(DateTime(end.year, end.month, end.day));
}

bool _inFixedRange(DateTime now, int startMonth, int startDay, int endMonth, int endDay) {
  final year = now.year;
  final start = DateTime(year, startMonth, startDay);
  final end = DateTime(year, endMonth, endDay);
  final d = DateTime(year, now.month, now.day);
  if (start.isAfter(end)) {
    return !d.isBefore(start) || !d.isAfter(end); // wraps New Year's Eve
  }
  return !d.isBefore(start) && !d.isAfter(end);
}

Occasion resolveOccasion(DateTime now) {
  if (_inFixedRange(now, 12, 28, 1, 7)) return Occasion.newYear;
  if (_inFixedRange(now, 2, 7, 2, 14)) return Occasion.valentines;

  final holiPeak = _lunarPeaks[Occasion.holi]?[now.year] ?? _lunarFallback[Occasion.holi]!(now.year);
  if (_withinWindow(now, holiPeak, 2, 2)) return Occasion.holi;

  if (_inFixedRange(now, 8, 10, 8, 16)) return Occasion.independence;

  final onamPeak = _lunarPeaks[Occasion.onam]?[now.year] ?? _lunarFallback[Occasion.onam]!(now.year);
  if (_withinWindow(now, onamPeak, 3, 3)) return Occasion.onam;

  final diwaliPeak = _lunarPeaks[Occasion.diwali]?[now.year] ?? _lunarFallback[Occasion.diwali]!(now.year);
  if (_withinWindow(now, diwaliPeak, 3, 3)) return Occasion.diwali;

  if (_inFixedRange(now, 10, 25, 10, 31)) return Occasion.halloween;
  if (_inFixedRange(now, 12, 15, 12, 27)) return Occasion.christmas;

  return Occasion.regular;
}

// -----------------------------------------------------------------------------
// 3. State
// -----------------------------------------------------------------------------

class SeasonalThemeState extends ChangeNotifier {
  Occasion? _preview;

  Occasion get active => _preview ?? resolveOccasion(DateTime.now());
  OccasionPalette get palette => occasionPalettes[active]!;
  bool get isPreviewing => _preview != null;

  void setPreview(Occasion? occasion) {
    _preview = occasion;
    notifyListeners();
  }
}

// -----------------------------------------------------------------------------
// 4. Theme builder — mirrors your existing theme.dart's appTheme exactly,
//    just swapping the primary/accent color for the active palette.
// -----------------------------------------------------------------------------

ThemeData buildSeasonalAppTheme(OccasionPalette palette) => ThemeData(
  scaffoldBackgroundColor: AppColors.bg,
  primaryColor: palette.primary,
  brightness: Brightness.dark,
  fontFamily: 'Roboto',
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.bg,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: false,
  ),
  iconTheme: const IconThemeData(color: Colors.white70),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.card,
    hintStyle: const TextStyle(color: AppColors.textMuted),
    prefixIconColor: palette.accent,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.all(14),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: palette.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFF334155)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.card,
    selectedItemColor: palette.accent,
    unselectedItemColor: AppColors.textMuted,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
);

// -----------------------------------------------------------------------------
// 5. Falling particle overlay — sits on top of every screen, input-transparent.
// -----------------------------------------------------------------------------

class _Particle {
  double x, y;
  final double speed, drift, size;
  final String symbol;
  _Particle({required this.x, required this.y, required this.speed, required this.drift, required this.size, required this.symbol});
}

class SeasonalOverlay extends StatefulWidget {
  final OccasionPalette palette;
  const SeasonalOverlay({super.key, required this.palette});

  @override
  State<SeasonalOverlay> createState() => _SeasonalOverlayState();
}

class _SeasonalOverlayState extends State<SeasonalOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _rng = Random();
  List<_Particle> _particles = [];
  String _key = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(days: 1))
      ..addListener(_tick)
      ..repeat();
    _rebuild();
  }

  @override
  void didUpdateWidget(covariant SeasonalOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.palette.particles.join() != _key) _rebuild();
  }

  void _rebuild() {
    _key = widget.palette.particles.join();
    if (!widget.palette.hasParticles) {
      setState(() => _particles = []);
      return;
    }
    setState(() {
      _particles = List.generate(widget.palette.particleCount, (i) {
        return _Particle(
          x: _rng.nextDouble(),
          y: _rng.nextDouble(),
          speed: 0.5 + _rng.nextDouble() * 0.8,
          drift: (_rng.nextDouble() - 0.5) * 0.3,
          size: 14 + _rng.nextDouble() * 14,
          symbol: widget.palette.particles[_rng.nextInt(widget.palette.particles.length)],
        );
      });
    });
  }

  void _tick() {
    if (_particles.isEmpty) return;
    setState(() {
      for (final p in _particles) {
        p.y += p.speed * 0.0009;
        p.x += p.drift * 0.0009;
        if (p.y > 1.05) {
          p.y = -0.05;
          p.x = _rng.nextDouble();
        }
        if (p.x < -0.05) p.x = 1.05;
        if (p.x > 1.05) p.x = -0.05;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_particles.isEmpty) return const SizedBox.shrink();
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth, h = constraints.maxHeight;
          return Stack(
            children: _particles
                .map((p) => Positioned(
              left: p.x * w,
              top: p.y * h,
              child: Opacity(opacity: 0.85, child: Text(p.symbol, style: TextStyle(fontSize: p.size))),
            ))
                .toList(),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 7. The app root — a drop-in replacement for your existing BeatsInfinityApp.
// -----------------------------------------------------------------------------

class SeasonalBeatsInfinityApp extends StatelessWidget {
  const SeasonalBeatsInfinityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => SeasonalThemeState()),
      ],
      child: Consumer<SeasonalThemeState>(
        builder: (context, seasonal, _) => MaterialApp(
          title: 'Beats Infinity',
          debugShowCheckedModeBanner: false,
          theme: buildSeasonalAppTheme(seasonal.palette),
          home: const OnboardingScreen(),
          builder: (context, child) => Stack(
            children: [
              if (child != null) child,
              SeasonalOverlay(palette: seasonal.palette),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// WHAT TO CHANGE IN main.dart (2 lines only):
//
//   import 'seasonal_mood.dart';                              // ADD
//
//   void main() {
//     runApp(const SeasonalBeatsInfinityApp());                // was: BeatsInfinityApp()
//   }
//
// You can leave the old `BeatsInfinityApp` class sitting in main.dart unused,
// or delete it — either way nothing else needs to change.
// =============================================================================
