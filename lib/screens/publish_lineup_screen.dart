import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/initials_avatar.dart';

class PublishLineupScreen extends StatelessWidget {
  final String eventId;
  const PublishLineupScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final eventPairs = appState.pairs.where((p) => p.eventId == eventId).toList();
    String name(String id) => appState.singers.firstWhere((s) => s.id == id).name;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.rocket_launch_rounded, color: AppColors.success, size: 20),
            SizedBox(width: 8),
            Text('Final Review'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
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
                      const Icon(Icons.favorite, color: AppColors.pink, size: 12),
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
                            Row(
                              children: [
                                Icon(Icons.music_note_rounded, size: 12, color: p.karaokeLink != null ? AppColors.teal : AppColors.textMuted),
                                const SizedBox(width: 4),
                                Text(p.karaokeLink ?? 'Track not set',
                                    style: TextStyle(color: p.karaokeLink != null ? AppColors.teal : const Color(0xFF64748B), fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                onPressed: () {
                  if (eventPairs.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Generate pairing before publishing.')));
                    return;
                  }
                  context.read<AppState>().publishEvent(eventId);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('🚀 Published! All singers notified.')));
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.rocket_launch_rounded),
                label: const Text('Publish Lineup to All Singers'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
