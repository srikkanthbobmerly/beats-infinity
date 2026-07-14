enum Gender { male, female }

class Singer {
  final String id;
  final String name;
  final Gender gender;
  final String phone;
  final bool isAdmin;

  Singer({
    required this.id,
    required this.name,
    required this.gender,
    required this.phone,
    this.isAdmin = false,
  });
}

enum EventStatus { open, closed, published }

class SingerEvent {
  final String id;
  String theme;
  String eventDate;
  String submissionDeadline;
  EventStatus status;
  String? posterPath;

  SingerEvent({
    required this.id,
    required this.theme,
    required this.eventDate,
    required this.submissionDeadline,
    this.status = EventStatus.open,
    this.posterPath,
  });
}

class Song {
  final String id;
  final String eventId;
  final String singerId;
  final String singerName;
  final String title;
  final String artist;
  final String language;

  Song({
    required this.id,
    required this.eventId,
    required this.singerId,
    required this.singerName,
    required this.title,
    required this.artist,
    required this.language,
  });
}

class SingerPair {
  final String id;
  final String eventId;
  final String singer1Id;
  final String singer2Id;
  final String songTitle;
  String? karaokeLink;
  bool confirmed;
  bool paid;
  double confirmationFee;

  SingerPair({
    required this.id,
    required this.eventId,
    required this.singer1Id,
    required this.singer2Id,
    required this.songTitle,
    this.karaokeLink,
    this.confirmed = false,
    this.paid = false,
    this.confirmationFee = 99.0,
  });
}

class UnmatchedSlot {
  final String singerId;
  final String singerName;
  final int remainingSlots;

  UnmatchedSlot({
    required this.singerId,
    required this.singerName,
    required this.remainingSlots,
  });
}