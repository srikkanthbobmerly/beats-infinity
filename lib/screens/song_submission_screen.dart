import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../theme.dart';

class SongSubmissionScreen extends StatefulWidget {
  final String eventId;
  const SongSubmissionScreen({super.key, required this.eventId});

  @override
  State<SongSubmissionScreen> createState() => _SongSubmissionScreenState();
}

class _SongSubmissionScreenState extends State<SongSubmissionScreen> {
  final _title = TextEditingController();
  final _artist = TextEditingController();
  final _language = TextEditingController(text: 'Hindi');

  void _submit() {
    if (_title.text.trim().isEmpty || _artist.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please enter both song title and artist.')));
      return;
    }

    final appState = context.read<AppState>();
    final singerName = appState.currentUser?.name ?? 'Unknown Singer';

    appState.addSong(Song(
      id: 's_${DateTime.now().millisecondsSinceEpoch}',
      eventId: widget.eventId,
      title: _title.text.trim(),
      artist: _artist.text.trim(),
      language: _language.text.trim().isEmpty ? 'Hindi' : _language.text.trim(),
      singerId: appState.currentUser?.id ?? '',
      singerName: singerName,
    ));

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('🎤 Song submitted!')));
    Navigator.of(context).pop();
  }

  void _fillFromSuggestion(Map<String, String> song) {
    setState(() {
      _title.text = song['title'] ?? '';
      _artist.text = song['artist'] ?? '';
      _language.text = song['language'] ?? 'Hindi';
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _artist.dispose();
    _language.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    SingerEvent? event;
    try {
      event = appState.events.firstWhere((e) => e.id == widget.eventId);
    } catch (_) {
      event = null;
    }
    final suggestions = event == null ? <Map<String, String>>[] : appState.suggestedSongsForTheme(event.theme);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.add_circle_rounded, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('Submit My Song'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event != null)
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(color: AppColors.cardAlt, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.celebration_rounded, color: AppColors.accent, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Theme: ${event.theme}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            if (suggestions.isNotEmpty) ...[
              const Text('Suggested for this theme', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: suggestions.map((s) {
                  return GestureDetector(
                    onTap: () => _fillFromSuggestion(s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.music_note_rounded, color: AppColors.accent, size: 14),
                          const SizedBox(width: 6),
                          Text(s['title'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 13)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
            TextField(
              controller: _title,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: 'Song title', prefixIcon: Icon(Icons.music_note_rounded)),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _artist,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: 'Original artist', prefixIcon: Icon(Icons.person_rounded)),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _language,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: 'Language (e.g. Hindi)', prefixIcon: Icon(Icons.language_rounded)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check_circle_rounded),
                label: const Text('Submit Song'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
