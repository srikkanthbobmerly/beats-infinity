import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';
import 'create_event_screen.dart';
import 'manage_singers_screen.dart';
import 'all_songs_screen.dart';
import 'auto_pairing_screen.dart';
import 'manual_pairing_screen.dart';
import 'karaoke_assign_screen.dart';
import 'publish_lineup_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final openEvent = appState.openEvent;
    final submissionCount = openEvent == null
        ? 0
        : appState.songs.where((s) => s.eventId == openEvent.id).length;

    final items = <_AdminItem>[
      _AdminItem(Icons.add_circle_outline_rounded, AppColors.primary, 'Create / Edit Event', 'Set the theme & dates', (_) => const CreateEventScreen()),
      _AdminItem(Icons.people_alt_rounded, AppColors.teal, 'Manage Singers', '${appState.singers.length} in the group', (_) => const ManageSingersScreen()),
      if (openEvent != null)
        _AdminItem(Icons.library_music_rounded, AppColors.gold, 'View All Submissions', '$submissionCount songs so far', (_) => AllSongsScreen(eventId: openEvent.id)),
      if (openEvent != null)
        _AdminItem(Icons.auto_awesome_rounded, AppColors.pink, 'Auto-Pairing', 'Run the smart matcher', (_) => AutoPairingScreen(eventId: openEvent.id)),
      if (openEvent != null)
        _AdminItem(Icons.pan_tool_alt_rounded, AppColors.accent, 'Manual Pairing', 'Assign pairs by hand', (_) => ManualPairingScreen(eventId: openEvent.id)),
      if (openEvent != null)
        _AdminItem(Icons.headphones_rounded, AppColors.teal, 'Assign Karaoke Tracks', 'Attach a link per pair', (_) => KaraokeAssignScreen(eventId: openEvent.id)),
      if (openEvent != null)
        _AdminItem(Icons.rocket_launch_rounded, AppColors.success, 'Publish Lineup', 'Notify everyone', (_) => PublishLineupScreen(eventId: openEvent.id)),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.admin_panel_settings_rounded, color: AppColors.accent, size: 20),
            SizedBox(width: 8),
            Text('Admin Dashboard'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(child: _statBox(Icons.groups_rounded, '${appState.singers.length}', 'Singers', AppColors.teal)),
              const SizedBox(width: 10),
              Expanded(child: _statBox(Icons.music_note_rounded, '$submissionCount', 'Songs In', AppColors.pink)),
            ],
          ),
          const SizedBox(height: 20),
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
      ),
    );
  }

  Widget _statBox(IconData icon, String num, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration(),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(num, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
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
