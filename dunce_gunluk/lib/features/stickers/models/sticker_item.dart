/// Dijital çıkartma verisini temsil eden model.
class StickerItem {
  final String id;
  final String type; // 'icon', 'text', 'vintage_label'
  final String value;
  double x;
  double y;
  double scale;
  double rotation;

  StickerItem({
    required this.id,
    required this.type,
    required this.value,
    this.x = 40.0,
    this.y = 40.0,
    this.scale = 1.0,
    this.rotation = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'value': value,
        'x': x,
        'y': y,
        'scale': scale,
        'rotation': rotation,
      };

  factory StickerItem.fromJson(Map<String, dynamic> json) => StickerItem(
        id: json['id'] as String,
        type: json['type'] as String,
        value: json['value'] as String,
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        scale: (json['scale'] as num?)?.toDouble() ?? 1.0,
        rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      );
}
