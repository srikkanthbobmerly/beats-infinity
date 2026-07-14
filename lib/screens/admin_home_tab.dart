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
      _AdminItem(
        icon: Icons.add_circle_outline_rounded,
        color: AppColors.primary,
        title: 'Create / Edit Event',
        subtitle: 'Set the theme & dates',
        builder: (_) => const CreateEventScreen(),
      ),
      if (openEvent != null)
        _AdminItem(
          icon: Icons.favorite_rounded,
          color: AppColors.pink,
          title: 'Pairing',
          subtitle: 'Auto-match or pair manually',
          onTap: (ctx) => _showPairingSheet(ctx, openEvent.id),
        ),
      if (openEvent != null)
        _AdminItem(
          icon: Icons.headphones_rounded,
          color: AppColors.teal,
          title: 'Assign Karaoke Tracks',
          subtitle: 'Attach a link per pair',
          builder: (_) => KaraokeAssignScreen(eventId: openEvent.id),
        ),
      if (openEvent != null)
        _AdminItem(
          icon: Icons.rocket_launch_rounded,
          color: AppColors.success,
          title: 'Publish Lineup',
          subtitle: 'Notify everyone',
          builder: (_) => PublishLineupScreen(eventId: openEvent.id),
        ),
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
              onTap: () {
                if (item.onTap != null) {
                  item.onTap!(context);
                } else if (item.builder != null) {
                  Navigator.of(context).push(MaterialPageRoute(builder: item.builder!));
                }
              },
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

/// Bottom sheet shown when the admin taps "Pairing" — lets them choose
/// between the smart auto-matcher and doing it by hand.
void _showPairingSheet(BuildContext context, String eventId) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) => Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: AppColors.cardAlt, borderRadius: BorderRadius.circular(4)),
            ),
          ),
          const Text('Pairing', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text(
            "Choose how you'd like to pair singers for this event.",
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 22),
          _PairingOption(
            icon: Icons.auto_awesome_rounded,
            color: AppColors.pink,
            title: 'Auto-Pairing',
            subtitle: 'Run the smart matcher',
            onTap: () {
              Navigator.of(sheetContext).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => AutoPairingScreen(eventId: eventId)));
            },
          ),
          const SizedBox(height: 10),
          _PairingOption(
            icon: Icons.pan_tool_alt_rounded,
            color: AppColors.accent,
            title: 'Manual Pairing',
            subtitle: 'Assign pairs by hand',
            onTap: () {
              Navigator.of(sheetContext).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ManualPairingScreen(eventId: eventId)));
            },
          ),
        ],
      ),
    ),
  );
}

class _PairingOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PairingOption({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardAlt,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.18), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                    Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final Widget Function(BuildContext)? builder;
  final void Function(BuildContext)? onTap;

  _AdminItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.builder,
    this.onTap,
  }) : assert(builder != null || onTap != null, 'Provide either builder or onTap');
}
