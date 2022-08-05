class HackathonDocument {
  HackathonDocument({
    required this.participants,
    required this.startDate,
    required this.image,
    required this.mode,
    required this.name,
    required this.timeline,
    required this.url
  });
  
  final int participants;
  final int startDate;
  final String image;
  final String name;
  final String mode;
  final String timeline;
  final String url;
}