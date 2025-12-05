class Item {
  final String id;
  final String title;
  final String? imageUrl;
  final DateTime createdAt;

  Item({required this.id, required this.title, this.imageUrl, required this.createdAt});

  factory Item.fromMap(Map<String, dynamic> m) => Item(
        id: m['id'] ?? '',
        title: m['title'] ?? '',
        imageUrl: m['image_url'],
        createdAt: DateTime.tryParse(m['created_at'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'image_url': imageUrl,
        'created_at': createdAt.toIso8601String(),
      };
}
