import '../models/models.dart';

List<Singer> mockSingers = [
  Singer(id: 's1', name: 'Arjun', gender: Gender.male, phone: '9000000001'),
  Singer(id: 's2', name: 'Karthik', gender: Gender.male, phone: '9000000002'),
  Singer(id: 's3', name: 'Vignesh', gender: Gender.male, phone: '9000000003'),
  Singer(id: 's4', name: 'Priya', gender: Gender.female, phone: '9000000004'),
  Singer(id: 's5', name: 'Divya', gender: Gender.female, phone: '9000000005'),
  Singer(id: 's6', name: 'Meena', gender: Gender.female, phone: '9000000006'),
  Singer(id: 'admin1', name: 'Admin (You)', gender: Gender.male, phone: '9000000000', isAdmin: true),
];

List<SingerEvent> mockEvents = [
  SingerEvent(
    id: 'e1',
    theme: '90s Bollywood Special',
    eventDate: '2026-08-15',
    submissionDeadline: '2026-08-05',
    status: EventStatus.open,
  ),
];

List<Song> mockSongs = [
  Song(id: 'sg1', eventId: 'e1', singerId: 's1', singerName: 'Arjun', title: 'Tujhe Dekha To', artist: 'Kumar Sanu', language: 'Hindi'),
  Song(id: 'sg2', eventId: 'e1', singerId: 's4', singerName: 'Priya', title: 'Chura Liya', artist: 'Asha Bhosle', language: 'Hindi'),
  Song(id: 'sg3', eventId: 'e1', singerId: 's5', singerName: 'Divya', title: 'Ek Ladki Ko Dekha', artist: 'Kumar Sanu', language: 'Hindi'),
];
