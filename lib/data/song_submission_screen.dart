/// Curated song suggestions, keyed by a lowercase keyword that's matched
/// against an event's theme text (see AppState.suggestedSongsForTheme).
/// Add more keywords/entries here any time — no other file needs to change.
final Map<String, List<Map<String, String>>> songSuggestionsByKeyword = {
  '90s': [
    {'title': 'Tujhe Dekha To', 'artist': 'Kumar Sanu & Lata Mangeshkar', 'language': 'Hindi'},
    {'title': 'Chura Liya', 'artist': 'Asha Bhosle & Mohammed Rafi', 'language': 'Hindi'},
    {'title': 'Ek Ladki Ko Dekha', 'artist': 'Kumar Sanu', 'language': 'Hindi'},
    {'title': 'Pehla Nasha', 'artist': 'Udit Narayan & Sadhana Sargam', 'language': 'Hindi'},
  ],
  'bollywood': [
    {'title': 'Tujhe Dekha To', 'artist': 'Kumar Sanu & Lata Mangeshkar', 'language': 'Hindi'},
    {'title': 'Tum Hi Ho', 'artist': 'Arijit Singh', 'language': 'Hindi'},
    {'title': 'Gerua', 'artist': 'Arijit Singh & Antara Mitra', 'language': 'Hindi'},
  ],
  'valentine': [
    {'title': 'Tum Hi Ho', 'artist': 'Arijit Singh', 'language': 'Hindi'},
    {'title': 'Raabta', 'artist': 'Arijit Singh', 'language': 'Hindi'},
    {'title': 'Perfect', 'artist': 'Ed Sheeran', 'language': 'English'},
  ],
  'love': [
    {'title': 'Tum Hi Ho', 'artist': 'Arijit Singh', 'language': 'Hindi'},
    {'title': 'Raabta', 'artist': 'Arijit Singh', 'language': 'Hindi'},
  ],
  'rock': [
    {'title': 'Rock On', 'artist': 'Farhan Akhtar', 'language': 'Hindi'},
    {'title': 'Sadda Haq', 'artist': 'Mohit Chauhan', 'language': 'Hindi'},
  ],
  'sufi': [
    {'title': 'Kun Faya Kun', 'artist': 'A.R. Rahman & Javed Ali', 'language': 'Hindi'},
    {'title': 'Tajdar-e-Haram', 'artist': 'Atif Aslam', 'language': 'Urdu'},
  ],
  'diwali': [
    {'title': 'Deewani Mastani', 'artist': 'Shreya Ghoshal', 'language': 'Hindi'},
    {'title': 'Radha', 'artist': 'Shreya Ghoshal', 'language': 'Hindi'},
  ],
  'default': [
    {'title': 'Tum Hi Ho', 'artist': 'Arijit Singh', 'language': 'Hindi'},
    {'title': 'Kal Ho Naa Ho', 'artist': 'Sonu Nigam', 'language': 'Hindi'},
    {'title': 'Perfect', 'artist': 'Ed Sheeran', 'language': 'English'},
  ],
};
