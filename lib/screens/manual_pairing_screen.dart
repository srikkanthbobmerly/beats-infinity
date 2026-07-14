import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/initials_avatar.dart';

class ManualPairingScreen extends StatefulWidget {
  final String eventId;
  const ManualPairingScreen({super.key, required this.eventId});

  @override
  State<ManualPairingScreen> createState() => _ManualPairingScreenState();
}

class _ManualPairingScreenState extends State<ManualPairingScreen> {
  String? selectedMale;
  String? selectedFemale;
  final _songTitle = TextEditingController();
  late List<SingerPair> localPairs;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    localPairs = appState.pairs.where((p) => p.eventId == widget.eventId).toList();
  }

  void _addPair() {
    if (selectedMale == null || selectedFemale == null || _songTitle.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Select both singers and enter a song.')));
      return;
    }
    setState(() {
      localPairs.add(SingerPair(
        id: 'pair_manual_${DateTime.now().millisecondsSinceEpoch}',
        eventId: widget.eventId,
        singer1Id: selectedMale!,
        singer2Id: selectedFemale!,
        songTitle: _songTitle.text.trim(),
      ));
      selectedMale = null;
      selectedFemale = null;
      _songTitle.clear();
    });
  }

  void _save() {
    context.read<AppState>().savePairsManually(widget.eventId, localPairs);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Manual pairing saved.')));
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final males = appState.singers.where((s) => s.gender == Gender.male && !s.isAdmin).toList();
    final females = appState.singers.where((s) => s.gender == Gender.female && !s.isAdmin).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.pan_tool_alt_rounded, color: AppColors.accent, size: 20),
            SizedBox(width: 8),
            Text('Manual Pairing'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: const [
              Icon(Icons.male_rounded, size: 16, color: AppColors.accent),
              SizedBox(width: 6),
              Text('Select Male Singer', style: TextStyle(color: AppColors.textMuted)),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: males.map((m) => _chip(m.name, selectedMale == m.id, () {
                  setState(() => selectedMale = m.id);
                })).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Icon(Icons.female_rounded, size: 16, color: AppColors.pink),
              SizedBox(width: 6),
              Text('Select Female Singer', style: TextStyle(color: AppColors.textMuted)),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: females.map((f) => _chip(f.name, selectedFemale == f.id, () {
                  setState(() => selectedFemale = f.id);
                })).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _songTitle,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(hintText: 'Song title for this pair', prefixIcon: Icon(Icons.music_note_rounded)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(onPressed: _addPair, icon: const Icon(Icons.add_rounded), label: const Text('Add Pair')),
          ),
          const SizedBox(height: 24),
          Text('Current Pairs (${localPairs.length})',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...localPairs.map((p) {
            final n1 = appState.singers.firstWhere((s) => s.id == p.singer1Id).name;
            final n2 = appState.singers.firstWhere((s) => s.id == p.singer2Id).name;
            return Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: cardDecoration(),
              child: Row(
                children: [
                  InitialsAvatar(name: n1, radius: 16),
                  const SizedBox(width: 4),
                  const Icon(Icons.confirmation_num_rounded, color: AppColors.pink, size: 12),
                  const SizedBox(width: 4),
                  InitialsAvatar(name: n2, radius: 16),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$n1 & $n2', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        Text(p.songTitle, style: const TextStyle(color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(onPressed: _save, icon: const Icon(Icons.save_rounded), label: const Text('Save Pairing')),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InitialsAvatar(name: label, radius: 10),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
