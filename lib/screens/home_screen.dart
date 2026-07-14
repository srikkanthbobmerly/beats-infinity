import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/quick_action_tile.dart';
import '../widgets/initials_avatar.dart';
import '../data/song_submission_screen.dart';
import 'all_songs_screen.dart';
import 'my_pairing_screen.dart';
import 'published_lineup_screen.dart';
import 'event_history_screen.dart';

/// Content of the "Home" tab — no Scaffold/AppBar of its own,
/// it lives inside MainTabScreen's shared Scaffold.
class HomeTabBody extends StatelessWidget {
  const HomeTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final openEvent = appState.openEvent;
    final eventSongs = openEvent == null
        ? <dynamic>[]
        : appState.songs.where((s) => s.eventId == openEvent.id).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      children: [
        if (openEvent != null)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: gradientPrimary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: AppColors.primary.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.celebration_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 6),
                    Text('THIS MONTH\'S THEME',
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(openEvent.theme,
                    style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.event_rounded, color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    Text(openEvent.eventDate, style: const TextStyle(color: Colors.white70)),
                    const SizedBox(width: 16),
                    const Icon(Icons.timer_outlined, color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    Text('Due ${openEvent.submissionDeadline}', style: const TextStyle(color: Colors.white70)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primaryDark),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => SongSubmissionScreen(eventId: openEvent.id))),
                    icon: const Icon(Icons.add_circle_rounded),
                    label: const Text('Submit My Song', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(24),
            decoration: cardDecoration(),
            child: const Column(
              children: [
                Icon(Icons.hourglass_empty_rounded, color: AppColors.textMuted, size: 32),
                SizedBox(height: 10),
                Text('No open event right now.\nCheck back soon! 🎶',
                    textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted)),
              ],
            ),
          ),
        const SizedBox(height: 24),
        const Text('Quick Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.82,
          children: [
            QuickActionTile(
              icon: Icons.library_music_rounded,
              label: 'All Songs',
              color: AppColors.teal,
              badge: eventSongs.isNotEmpty ? '${eventSongs.length}' : null,
              onTap: () => openEvent == null
                  ? null
                  : Navigator.of(context).push(MaterialPageRoute(builder: (_) => AllSongsScreen(eventId: openEvent.id))),
            ),
            QuickActionTile(
              icon: Icons.favorite_rounded,
              label: 'My Pairing',
              color: AppColors.pink,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyPairingScreen())),
            ),
            QuickActionTile(
              icon: Icons.queue_music_rounded,
              label: 'Lineup',
              color: AppColors.gold,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PublishedLineupScreen())),
            ),
            QuickActionTile(
              icon: Icons.history_rounded,
              label: 'History',
              color: AppColors.accent,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EventHistoryScreen())),
            ),
          ],
        ),
        const SizedBox(height: 28),
        if (eventSongs.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Fresh Submissions 🎤', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              GestureDetector(
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => AllSongsScreen(eventId: openEvent!.id))),
                child: const Text('See all', style: TextStyle(color: AppColors.accent, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...eventSongs.take(3).map((s) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: cardDecoration(),
            child: Row(
              children: [
                InitialsAvatar(name: s.singerName, radius: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      Text('${s.singerName} · ${s.language}', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.music_note_rounded, color: AppColors.textMuted, size: 18),
              ],
            ),
          )),
        ],
      ],
    );
  }
}
