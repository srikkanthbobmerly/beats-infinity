import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/initials_avatar.dart';

class MyPairingScreen extends StatelessWidget {
  const MyPairingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.currentUser;
    final myPairs = appState.pairs
        .where((p) => p.singer1Id == user?.id || p.singer2Id == user?.id)
        .toList();

    String partnerName(dynamic p) {
      final partnerId = p.singer1Id == user?.id ? p.singer2Id : p.singer1Id;
      return appState.singers.firstWhere((s) => s.id == partnerId).name;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.favorite_rounded, color: AppColors.pink, size: 20),
            SizedBox(width: 8),
            Text('My Pairings'),
          ],
        ),
      ),
      body: myPairs.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.hourglass_empty_rounded, color: AppColors.textMuted, size: 40),
                  SizedBox(height: 10),
                  Text('No pairing published for you yet.', style: TextStyle(color: AppColors.textMuted)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: myPairs.length,
              itemBuilder: (context, i) {
                final p = myPairs[i];
                final partner = partnerName(p);
                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InitialsAvatar(name: user?.name ?? '', radius: 22),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: AppColors.pink, shape: BoxShape.circle),
                            child: const Icon(Icons.favorite, color: Colors.white, size: 12),
                          ),
                          InitialsAvatar(name: partner, radius: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text('$partner', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.mic_rounded, size: 16, color: Colors.white70),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(p.songTitle, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.music_note_rounded, size: 14, color: p.karaokeLink != null ? AppColors.teal : AppColors.textMuted),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(p.karaokeLink ?? 'Karaoke track not assigned yet',
                                style: TextStyle(color: p.karaokeLink != null ? AppColors.teal : AppColors.textMuted, fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
