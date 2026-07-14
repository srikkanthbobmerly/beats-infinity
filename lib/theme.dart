import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFF0B1120);
  static const card = Color(0xFF1A2437);
  static const cardAlt = Color(0xFF212D45);
  static const primary = Color(0xFF7C6EF6);
  static const primaryDark = Color(0xFF5B4FE0);
  static const accent = Color(0xFF9F8BFF);
  static const pink = Color(0xFFF564A9);
  static const teal = Color(0xFF2DD4BF);
  static const gold = Color(0xFFFBBF24);
  static const textMain = Colors.white;
  static const textMuted = Color(0xFF94A3B8);
  static const success = Color(0xFF22C55E);
  static const danger = Color(0xFFF87171);

  // playful palette used to color singer avatars, cycled by name hash
  static const avatarPalette = [
    Color(0xFFF564A9),
    Color(0xFF7C6EF6),
    Color(0xFF2DD4BF),
    Color(0xFFFBBF24),
    Color(0xFFFB923C),
    Color(0xFF60A5FA),
    Color(0xFFA3E635),
  ];

  static Color forName(String name) {
    final idx = name.isEmpty ? 0 : name.codeUnitAt(0) % avatarPalette.length;
    return avatarPalette[idx];
  }
}

const gradientPrimary = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [AppColors.primary, Color(0xFFB06AB3)],
);

const gradientWarm = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [AppColors.pink, AppColors.gold],
);

BoxDecoration cardDecoration({Color? color}) => BoxDecoration(
      color: color ?? AppColors.card,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 10, offset: const Offset(0, 4)),
      ],
    );

final appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.bg,
  primaryColor: AppColors.primary,
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
    prefixIconColor: AppColors.accent,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.all(14),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
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
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.card,
    selectedItemColor: AppColors.accent,
    unselectedItemColor: AppColors.textMuted,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
);
