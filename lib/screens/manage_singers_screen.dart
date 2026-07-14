import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/initials_avatar.dart';

class ManageSingersScreen extends StatelessWidget {
  const ManageSingersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final singers = context.watch<AppState>().singers;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.people_alt_rounded, color: AppColors.teal, size: 20),
            const SizedBox(width: 8),
            Text('Singers (${singers.length})'),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: singers.length,
        itemBuilder: (context, i) {
          final s = singers[i];
          return Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: cardDecoration(),
            child: Row(
              children: [
                InitialsAvatar(name: s.name, radius: 20),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(s.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          if (s.isAdmin) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                              child: const Text('ADMIN', style: TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(s.phone, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                Icon(
                  s.gender == Gender.male ? Icons.male_rounded : Icons.female_rounded,
                  color: s.gender == Gender.male ? AppColors.accent : AppColors.pink,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
