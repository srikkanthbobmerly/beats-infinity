import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme.dart';

class EventHistoryScreen extends StatelessWidget {
  const EventHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final pastEvents = appState.events.where((e) => e.status == EventStatus.published).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.history_rounded, color: AppColors.accent, size: 20),
            SizedBox(width: 8),
            Text('Past Events'),
          ],
        ),
      ),
      body: pastEvents.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.archive_outlined, color: AppColors.textMuted, size: 40),
                  SizedBox(height: 10),
                  Text('No past events yet.', style: TextStyle(color: AppColors.textMuted)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: pastEvents.length,
              itemBuilder: (context, i) {
                final e = pastEvents[i];
                return Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: cardDecoration(),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.18), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.celebration_rounded, color: AppColors.accent),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.theme, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            Text(e.eventDate, style: const TextStyle(color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
