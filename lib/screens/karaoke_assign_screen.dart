import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/initials_avatar.dart';

class KaraokeAssignScreen extends StatefulWidget {
  final String eventId;
  const KaraokeAssignScreen({super.key, required this.eventId});

  @override
  State<KaraokeAssignScreen> createState() => _KaraokeAssignScreenState();
}

class _KaraokeAssignScreenState extends State<KaraokeAssignScreen> {
  final Map<String, TextEditingController> controllers = {};

  TextEditingController _controllerFor(String pairId, String? existing) {
    return controllers.putIfAbsent(pairId, () => TextEditingController(text: existing ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final eventPairs = appState.pairs.where((p) => p.eventId == widget.eventId).toList();
    String name(String id) => appState.singers.firstWhere((s) => s.id == id).name;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.headphones_rounded, color: AppColors.teal, size: 20),
            SizedBox(width: 8),
            Text('Assign Karaoke Tracks'),
          ],
        ),
      ),
      body: eventPairs.isEmpty
          ? const Center(
              child: Text('No pairs yet. Run pairing first.', style: TextStyle(color: AppColors.textMuted)))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: eventPairs.length,
              itemBuilder: (context, i) {
                final p = eventPairs[i];
                final controller = _controllerFor(p.id, p.karaokeLink);
                return Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InitialsAvatar(name: name(p.singer1Id), radius: 16),
                          const SizedBox(width: 4),
                          const Icon(Icons.confirmation_num_rounded, color: AppColors.pink, size: 12),
                          const SizedBox(width: 4),
                          InitialsAvatar(name: name(p.singer2Id), radius: 16),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text('${name(p.singer1Id)} & ${name(p.singer2Id)}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(p.songTitle, style: const TextStyle(color: AppColors.textMuted)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(hintText: 'Paste karaoke link (YouTube, etc.)', prefixIcon: Icon(Icons.link_rounded)),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<AppState>().assignKaraokeLink(p.id, controller.text);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(content: Text('🎧 Track saved.')));
                          },
                          icon: const Icon(Icons.check_rounded),
                          label: const Text('Save Track'),
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
