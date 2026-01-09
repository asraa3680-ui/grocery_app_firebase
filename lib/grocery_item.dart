import 'package:cloud_firestore/cloud_firestore.dart';

class GroceryItem {
  final String id;
  final String name;
  final int quantity;
  final DateTime createdAt;

  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.createdAt,
  });

  
  factory GroceryItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return GroceryItem(
      id: doc.id,
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
