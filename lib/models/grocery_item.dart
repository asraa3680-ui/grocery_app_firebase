class GroceryItem {
  final String id;
  final String name;
  final bool isDone;

  GroceryItem({required this.id, required this.name, this.isDone = false});

  // تحويل من JSON (قادم من فايربيس) إلى Object
  factory GroceryItem.fromJson(Map<String, dynamic> json, String id) {
    return GroceryItem(
      id: id,
      name: json['name'] ?? '',
      isDone: json['isDone'] ?? false,
    );
  }

  // تحويل من Object إلى JSON (لإرساله للفايربيس)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isDone': isDone,
    };
  }
}