class ItemModel {
  final String pageId;
  final String name;
  final String category;
  final double price;
  final DateTime date;

  const ItemModel({
    required this.pageId,
    required this.name,
    required this.category,
    required this.price,
    required this.date,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    final properties = map['properties'] as Map<String, dynamic>;
    final dateStr = properties['Date']?['date']?['start'];
    final pageId = map['id'];
    final name = properties['Name']?['title']?[0]?['plain_text'] ?? '?';
    final category = properties['Category']?['select']?['name'] ?? 'Any';
    final price = (properties['Price']?['number'] ?? 0).toDouble();
    final date = dateStr != null ? DateTime.parse(dateStr) : DateTime.now();
    return ItemModel(
      pageId: pageId,
      name: name,
      category: category,
      price: price,
      date: date,
    );
  }
}
