class GroceryItem {
  final String id;
  final String name;
  final bool isDone;

  GroceryItem({required this.id, required this.name, this.isDone = false});

 
  factory GroceryItem.fromJson(Map<String, dynamic> json, String id) {
    return GroceryItem(
      id: id,
      name: json['name'] ?? '',
      isDone: json['isDone'] ?? false,
    );
  }

 
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isDone': isDone,
    };
  }
}
