class FlashCard {
  final int pageNumber;
  final int ayahNumber;
  final int reviewCount;
  final DateTime? nextReview;
  final List<int> revealedAyahs;
  final int currentAyah;

  FlashCard({
    required this.pageNumber,
    required this.ayahNumber,
    required this.reviewCount,
    this.nextReview,
    this.revealedAyahs = const [],
    this.currentAyah = 1,
  });

  Map<String, dynamic> toJson() => {
        'pageNumber': pageNumber,
        'ayahNumber': ayahNumber,
        'reviewCount': reviewCount,
        'nextReview': nextReview?.toIso8601String(),
        'revealedAyahs': revealedAyahs,
        'currentAyah': currentAyah,
      };

  factory FlashCard.fromJson(Map<String, dynamic> json) => FlashCard(
        pageNumber: json['pageNumber'],
        ayahNumber: json['ayahNumber'],
        reviewCount: json['reviewCount'],
        nextReview: json['nextReview'] != null
            ? DateTime.parse(json['nextReview'])
            : null,
        revealedAyahs: List<int>.from(json['revealedAyahs'] ?? []),
        currentAyah: json['currentAyah'] ?? 1,
      );
}
