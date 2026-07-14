import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';
import 'create_event_screen.dart';
import 'auto_pairing_screen.dart';
import 'manual_pairing_screen.dart';
import 'karaoke_assign_screen.dart';
import 'publish_lineup_screen.dart';

/// Admin's main landing tab — stats + all admin actions.
/// No Scaffold/AppBar of its own; lives inside AdminMainScreen.
class AdminHomeTabBody extends StatelessWidget {
  const AdminHomeTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final openEvent = appState.openEvent;
    final submissionCount = openEvent == null
        ? 0
        : appState.songs.where((s) => s.eventId == openEvent.id).length;
    final pairCount = openEvent == null
        ? 0
        : appState.pairs.where((p) => p.eventId == openEvent.id).length;

    final items = <_AdminItem>[
      _AdminItem(Icons.add_circle_outline_rounded, AppColors.primary, 'Create / Edit Event', 'Set the theme & dates', (_) => const CreateEventScreen()),
      if (openEvent != null)
        _AdminItem(Icons.auto_awesome_rounded, AppColors.pink, 'Auto-Pairing', 'Run the smart matcher', (_) => AutoPairingScreen(eventId: openEvent.id)),
      if (openEvent != null)
        _AdminItem(Icons.pan_tool_alt_rounded, AppColors.accent, 'Manual Pairing', 'Assign pairs by hand', (_) => ManualPairingScreen(eventId: openEvent.id)),
      if (openEvent != null)
        _AdminItem(Icons.headphones_rounded, AppColors.teal, 'Assign Karaoke Tracks', 'Attach a link per pair', (_) => KaraokeAssignScreen(eventId: openEvent.id)),
      if (openEvent != null)
        _AdminItem(Icons.rocket_launch_rounded, AppColors.success, 'Publish Lineup', 'Notify everyone', (_) => PublishLineupScreen(eventId: openEvent.id)),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      children: [
        if (openEvent != null)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: gradientPrimary,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.campaign_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text('LIVE EVENT', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(openEvent.theme, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(20),
            decoration: cardDecoration(),
            child: const Row(
              children: [
                Icon(Icons.hourglass_empty_rounded, color: AppColors.textMuted),
                SizedBox(width: 12),
                Expanded(child: Text('No open event. Create one to get started.', style: TextStyle(color: AppColors.textMuted))),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _statBox(Icons.groups_rounded, '${appState.singers.length}', 'Singers', AppColors.teal)),
            const SizedBox(width: 10),
            Expanded(child: _statBox(Icons.music_note_rounded, '$submissionCount', 'Songs In', AppColors.pink)),
            const SizedBox(width: 10),
            Expanded(child: _statBox(Icons.favorite_rounded, '$pairCount', 'Pairs Set', AppColors.gold)),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Manage', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 12),
        ...items.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: item.builder)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: item.color.withOpacity(0.18), borderRadius: BorderRadius.circular(12)),
                          child: Icon(item.icon, color: item.color, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                              Text(item.subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _statBox(IconData icon, String num, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(num, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _AdminItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final Widget Function(BuildContext) builder;
  _AdminItem(this.icon, this.color, this.title, this.subtitle, this.builder);
}
