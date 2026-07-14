import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/initials_avatar.dart';

class SongsTabBody extends StatelessWidget {
  const SongsTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final openEvent = appState.openEvent;
    final eventSongs = openEvent == null
        ? []
        : appState.songs.where((s) => s.eventId == openEvent.id).toList();

    if (openEvent == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.queue_music_rounded, color: AppColors.textMuted, size: 40),
            SizedBox(height: 10),
            Text('No open event right now.', style: TextStyle(color: AppColors.textMuted)),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      children: [
        Row(
          children: [
            const Icon(Icons.library_music_rounded, color: AppColors.teal, size: 20),
            const SizedBox(width: 8),
            Text('${eventSongs.length} songs for "${openEvent.theme}"',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
        const SizedBox(height: 16),
        if (eventSongs.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: Text('No songs submitted yet. Be the first! 🎤', style: TextStyle(color: AppColors.textMuted))),
          )
        else
          ...eventSongs.map((s) => Container(
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
                          Text('${s.artist} · ${s.language}', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          const SizedBox(height: 3),
                          Text('by ${s.singerName}', style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
      ],
    );
  }
}
