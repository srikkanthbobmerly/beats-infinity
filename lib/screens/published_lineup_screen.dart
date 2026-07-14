import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/initials_avatar.dart';

class PublishedLineupScreen extends StatelessWidget {
  const PublishedLineupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    SingerEvent? publishedEvent;
    try {
      publishedEvent = appState.events.firstWhere((e) => e.status == EventStatus.published);
    } catch (_) {
      publishedEvent = null;
    }
    final lineupPairs = appState.pairs.where((p) => p.eventId == publishedEvent?.id).toList();
    String name(String id) => appState.singers.firstWhere((s) => s.id == id).name;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.queue_music_rounded, color: AppColors.gold, size: 20),
            const SizedBox(width: 8),
            Flexible(child: Text(publishedEvent != null ? publishedEvent.theme : 'No Lineup Yet', overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
      body: lineupPairs.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.event_busy_rounded, color: AppColors.textMuted, size: 40),
                  SizedBox(height: 10),
                  Text('Nothing published yet.', style: TextStyle(color: AppColors.textMuted)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: lineupPairs.length,
              itemBuilder: (context, i) {
                final p = lineupPairs[i];
                return Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: cardDecoration(),
                  child: Row(
                    children: [
                      InitialsAvatar(name: name(p.singer1Id), radius: 18),
                      const SizedBox(width: 6),
                      const Icon(Icons.favorite, color: AppColors.pink, size: 14),
                      const SizedBox(width: 6),
                      InitialsAvatar(name: name(p.singer2Id), radius: 18),
                      const SizedBox(width: 14),
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
    );
  }
}
