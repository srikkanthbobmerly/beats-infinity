import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/initials_avatar.dart';

class AllSongsScreen extends StatelessWidget {
  final String eventId;
  const AllSongsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final eventSongs = appState.songs.where((s) => s.eventId == eventId).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.library_music_rounded, color: AppColors.teal, size: 20),
            const SizedBox(width: 8),
            Text('Submitted Songs (${eventSongs.length})'),
          ],
        ),
      ),
      body: eventSongs.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.queue_music_rounded, color: AppColors.textMuted, size: 40),
                  SizedBox(height: 10),
                  Text('No songs submitted yet.', style: TextStyle(color: AppColors.textMuted)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: eventSongs.length,
              itemBuilder: (context, i) {
                final s = eventSongs[i];
                return Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: cardDecoration(),
                  child: Row(
                    children: [
                      InitialsAvatar(name: s.singerName, radius: 20),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(Icons.album_rounded, size: 13, color: AppColors.textMuted),
                                const SizedBox(width: 4),
                                Expanded(child: Text('${s.artist} · ${s.language}', style: const TextStyle(color: AppColors.textMuted, fontSize: 12), overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text('by ${s.singerName}', style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
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
