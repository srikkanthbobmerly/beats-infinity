import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/initials_avatar.dart';

class AutoPairingScreen extends StatelessWidget {
  final String eventId;
  const AutoPairingScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final eventPairs = appState.pairs.where((p) => p.eventId == eventId).toList();
    String name(String id) => appState.singers.firstWhere((s) => s.id == id).name;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.auto_awesome_rounded, color: AppColors.pink, size: 20),
            SizedBox(width: 8),
            Text('Auto-Pairing'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.cardAlt, borderRadius: BorderRadius.circular(10)),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textMuted),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Rule: each male → 3 duets · each female → paired by her song count',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.read<AppState>().runAutoPair(eventId),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Run Auto-Pair'),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: eventPairs.isEmpty
                  ? const Center(
                      child: Text('No pairs generated yet. Tap "Run Auto-Pair".',
                          style: TextStyle(color: AppColors.textMuted)))
                  : ListView.builder(
                      itemCount: eventPairs.length,
                      itemBuilder: (context, i) {
                        final p = eventPairs[i];
                        return Container(
                          padding: const EdgeInsets.all(14),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: cardDecoration(),
                          child: Row(
                            children: [
                              InitialsAvatar(name: name(p.singer1Id), radius: 16),
                              const SizedBox(width: 4),
                              const Icon(Icons.confirmation_num_rounded, color: AppColors.pink, size: 12),
                              const SizedBox(width: 4),
                              InitialsAvatar(name: name(p.singer2Id), radius: 16),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${name(p.singer1Id)} & ${name(p.singer2Id)}',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                    Text(p.songTitle, style: const TextStyle(color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
            const Text('Review these suggestions, then adjust manually before publishing.',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
