import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/initials_avatar.dart';
import 'admin_dashboard_screen.dart';
import 'event_history_screen.dart';
import 'login_screen.dart';

class ProfileTabBody extends StatelessWidget {
  final bool showAdminEntry;
  const ProfileTabBody({super.key, this.showAdminEntry = true});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.currentUser;
    if (user == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: cardDecoration(),
          child: Row(
            children: [
              InitialsAvatar(name: user.name, radius: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(user.gender == Gender.male ? Icons.male_rounded : Icons.female_rounded,
                            size: 14, color: user.gender == Gender.male ? AppColors.accent : AppColors.pink),
                        const SizedBox(width: 4),
                        Text(user.phone, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                      ],
                    ),
                    if (user.isAdmin) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                        child: const Text('ADMIN', style: TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (user.isAdmin && showAdminEntry)
          _menuRow(context, Icons.admin_panel_settings_rounded, AppColors.accent, 'Admin Dashboard',
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminDashboardScreen()))),
        _menuRow(context, Icons.history_rounded, AppColors.teal, 'Past Events',
                () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EventHistoryScreen()))),
        _menuRow(context, Icons.help_outline_rounded, AppColors.textMuted, 'Help & Support', () {}),
        const SizedBox(height: 12),
        _menuRow(context, Icons.logout_rounded, AppColors.danger, 'Logout', () {
          appState.logout();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
        }),
      ],
    );
  }

  Widget _menuRow(BuildContext context, IconData icon, Color color, String label, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.card,
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
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15))),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
