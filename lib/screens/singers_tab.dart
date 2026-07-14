import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/initials_avatar.dart';

class SingersTabBody extends StatelessWidget {
  const SingersTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    final singers = context.watch<AppState>().singers;
    final males = singers.where((s) => s.gender == Gender.male && !s.isAdmin).length;
    final females = singers.where((s) => s.gender == Gender.female && !s.isAdmin).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: cardDecoration(),
                child: Column(
                  children: [
                    const Icon(Icons.male_rounded, color: AppColors.accent),
                    const SizedBox(height: 6),
                    Text('$males', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const Text('Male', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: cardDecoration(),
                child: Column(
                  children: [
                    const Icon(Icons.female_rounded, color: AppColors.pink),
                    const SizedBox(height: 6),
                    Text('$females', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const Text('Female', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text('All Singers (${singers.length})', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 12),
        ...singers.map((s) => Container(
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
            )),
      ],
    );
  }
}
