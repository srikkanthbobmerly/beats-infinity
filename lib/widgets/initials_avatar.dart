import 'package:flutter/material.dart';
import '../theme.dart';

class InitialsAvatar extends StatelessWidget {
  final String name;
  final double radius;
  const InitialsAvatar({super.key, required this.name, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? '?'
        : name.trim().split(RegExp(r'\s+')).take(2).map((w) => w[0].toUpperCase()).join();
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.forName(name),
      child: Text(
        initials,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: radius * 0.7),
      ),
    );
  }
}
