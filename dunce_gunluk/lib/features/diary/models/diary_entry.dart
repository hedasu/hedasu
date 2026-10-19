import '../../stickers/models/sticker_item.dart';

/// Günlük ve anı kaydını temsil eden model.
class DiaryEntry {
  final String id;
  final String dateKey; // 'yyyy-MM-dd'
  final String title;
  final String content;
  final String mood; // 'happy', 'melancholy', 'thoughtful', 'excited', 'grateful', 'tired'
  final String? imagePath;
  final List<StickerItem> stickers;
  final DateTime updatedAt;

  DiaryEntry({
    required this.id,
    required this.dateKey,
    required this.title,
    required this.content,
    this.mood = 'thoughtful',
    this.imagePath,
    List<StickerItem>? stickers,
    DateTime? updatedAt,
  })  : stickers = stickers ?? [],
        updatedAt = updatedAt ?? DateTime.now();

  DiaryEntry copyWith({
    String? id,
    String? dateKey,
    String? title,
    String? content,
    String? mood,
    String? imagePath,
    List<StickerItem>? stickers,
    DateTime? updatedAt,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      dateKey: dateKey ?? this.dateKey,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      imagePath: imagePath ?? this.imagePath,
      stickers: stickers ?? List.from(this.stickers),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'dateKey': dateKey,
        'title': title,
        'content': content,
        'mood': mood,
        'imagePath': imagePath,
        'stickers': stickers.map((s) => s.toJson()).toList(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'] as String,
      dateKey: json['dateKey'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      mood: (json['mood'] as String?) ?? 'thoughtful',
      imagePath: json['imagePath'] as String?,
      stickers: (json['stickers'] as List<dynamic>?)
              ?.map((e) => StickerItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }
}
