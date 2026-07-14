import '../models/models.dart';

/// Auto-pairing rules for Beats Infinity:
/// - Every MALE singer must end up in exactly 3 duet pairs.
/// - Every FEMALE singer's pair count equals the number of songs SHE submitted.
/// - A male and female should not be paired with each other more than once
///   in the same event, if it can be avoided.
/// - Prefers assigning a song that the female singer in the pair actually submitted.
/// This is a greedy round-robin matcher, not a perfect solver. It guarantees
/// a valid, conflict-free result where possible, and reports any leftover
/// slots that couldn't be filled so the admin can resolve them manually.
class AutoPairResult {
  final List<SingerPair> pairs;
  final List<UnmatchedSlot> unmatched;
  AutoPairResult({required this.pairs, required this.unmatched});
}

AutoPairResult autoPair(String eventId, List<Singer> singers, List<Song> songs) {
  final males = singers.where((s) => s.gender == Gender.male && !s.isAdmin).toList();
  final females = singers.where((s) => s.gender == Gender.female && !s.isAdmin).toList();

  final maleSlots = {for (var m in males) m.id: 3};

  final femaleSlots = <String, int>{};
  for (var f in females) {
    final count = songs.where((sg) => sg.singerId == f.id).length;
    if (count > 0) femaleSlots[f.id] = count;
  }

  final femaleSongQueue = <String, List<Song>>{
    for (var f in females) f.id: songs.where((sg) => sg.singerId == f.id).toList(),
  };

  final usedPairs = <String>{};
  final pairs = <SingerPair>[];
  var pairCounter = 1;

  bool progress = true;
  while (progress) {
    progress = false;

    for (final male in males) {
      final mSlots = maleSlots[male.id] ?? 0;
      if (mSlots <= 0) continue;

      Singer? chosen;
      for (final f in females) {
        final fSlots = femaleSlots[f.id] ?? 0;
        if (fSlots > 0 && !usedPairs.contains('${male.id}|${f.id}')) {
          chosen = f;
          break;
        }
      }
      chosen ??= females.firstWhere(
        (f) => (femaleSlots[f.id] ?? 0) > 0,
        orElse: () => Singer(id: '', name: '', gender: Gender.female, phone: ''),
      );
      if (chosen.id.isEmpty) continue;

      final female = chosen;
      final queue = femaleSongQueue[female.id] ?? [];
      final songTitle = queue.isNotEmpty ? queue.removeAt(0).title : '(song TBD)';

      pairs.add(SingerPair(
        id: 'pair_${pairCounter++}',
        eventId: eventId,
        singer1Id: male.id,
        singer2Id: female.id,
        songTitle: songTitle,
      ));

      usedPairs.add('${male.id}|${female.id}');
      maleSlots[male.id] = mSlots - 1;
      femaleSlots[female.id] = (femaleSlots[female.id] ?? 0) - 1;
      progress = true;
    }
  }

  final unmatched = <UnmatchedSlot>[
    ...males.where((m) => (maleSlots[m.id] ?? 0) > 0).map(
        (m) => UnmatchedSlot(singerId: m.id, singerName: m.name, remainingSlots: maleSlots[m.id]!)),
    ...females.where((f) => (femaleSlots[f.id] ?? 0) > 0).map(
        (f) => UnmatchedSlot(singerId: f.id, singerName: f.name, remainingSlots: femaleSlots[f.id]!)),
  ];

  return AutoPairResult(pairs: pairs, unmatched: unmatched);
}
