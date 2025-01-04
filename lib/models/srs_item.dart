class SRSItem {
  final int pageNumber;
  final int ayahNumber;
  int level;
  int consecutiveCorrect;
  DateTime? nextReview;

  SRSItem({
    required this.pageNumber,
    required this.ayahNumber,
    this.level = 0,
    this.consecutiveCorrect = 0,
    this.nextReview,
  });

  factory SRSItem.fromJson(Map<String, dynamic> json) => SRSItem(
        pageNumber: json['pageNumber'],
        ayahNumber: json['ayahNumber'],
        level: json['level'],
        consecutiveCorrect: json['consecutiveCorrect'],
        nextReview: json['nextReview'] != null
            ? DateTime.parse(json['nextReview'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'pageNumber': pageNumber,
        'ayahNumber': ayahNumber,
        'level': level,
        'consecutiveCorrect': consecutiveCorrect,
        'nextReview': nextReview?.toIso8601String(),
      };
}
