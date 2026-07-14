import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../data/mock_data.dart';
import '../data/song_suggestions.dart';
import '../utils/pairing.dart';

class AppState extends ChangeNotifier {
  Singer? currentUser;
  final List<Singer> singers = List.from(mockSingers);
  final List<SingerEvent> events = List.from(mockEvents);
  final List<Song> songs = List.from(mockSongs);
  final List<SingerPair> pairs = [];

  bool login(String phone) {
    try {
      currentUser = singers.firstWhere((s) => s.phone == phone);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  void addSong(Song song) {
    songs.add(song);
    notifyListeners();
  }

  void removeSong(String songId) {
    songs.removeWhere((s) => s.id == songId);
    notifyListeners();
  }

  void createEvent(String theme, String eventDate, String deadline, {String? posterPath}) {
    events.add(SingerEvent(
      id: 'e_${DateTime.now().millisecondsSinceEpoch}',
      theme: theme,
      eventDate: eventDate,
      submissionDeadline: deadline,
      posterPath: posterPath,
    ));
    notifyListeners();
  }

  void runAutoPair(String eventId) {
    final eventSongs = songs.where((s) => s.eventId == eventId).toList();
    final result = autoPair(eventId, singers, eventSongs);
    pairs.removeWhere((p) => p.eventId == eventId);
    pairs.addAll(result.pairs);
    notifyListeners();
  }

  void savePairsManually(String eventId, List<SingerPair> newPairs) {
    pairs.removeWhere((p) => p.eventId == eventId);
    pairs.addAll(newPairs);
    notifyListeners();
  }

  void assignKaraokeLink(String pairId, String link) {
    final pair = pairs.firstWhere((p) => p.id == pairId);
    pair.karaokeLink = link;
    notifyListeners();
  }

  void publishEvent(String eventId) {
    final event = events.firstWhere((e) => e.id == eventId);
    event.status = EventStatus.published;
    notifyListeners();
  }

  SingerEvent? get openEvent {
    try {
      return events.firstWhere((e) => e.status == EventStatus.open);
    } catch (_) {
      return null;
    }
  }

  /// Curated song ideas that match an event's theme text, shown as tappable
  /// chips on the submission screen. Matching is a simple case-insensitive
  /// keyword lookup against [songSuggestionsByKeyword]; falls back to a
  /// generic evergreen list so the section still has something useful in it
  /// even for themes that don't hit a specific keyword.
  List<Map<String, String>> suggestedSongsForTheme(String theme) {
    final t = theme.toLowerCase();
    for (final entry in songSuggestionsByKeyword.entries) {
      if (entry.key != 'default' && t.contains(entry.key)) {
        return entry.value;
      }
    }
    return songSuggestionsByKeyword['default']!;
  }
}
