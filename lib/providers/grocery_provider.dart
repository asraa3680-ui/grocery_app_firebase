import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grocery_item.dart';

class GroceryProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<GroceryItem> _items = [];

  List<GroceryItem> get items => _items;

  void fetchItems() {
    _db.collection('groceries').snapshots().listen((snapshot) {
      _items = snapshot.docs.map((doc) {
        return GroceryItem.fromJson(doc.data(), doc.id);
      }).toList();
      notifyListeners(); اً
    });
  }

  Future<void> addItem(String name) async {
    final newItem = GroceryItem(id: '', name: name);
    await _db.collection('groceries').add(newItem.toJson());
  }

  Future<void> updateItem(String id, String newName) async {
    try {
      await _db.collection('groceries').doc(id).update({
        'name': newName,
      });
    } catch (e) {
      print("Error updating item: $e");
    }
  }

  Future<void> deleteItem(String id) async {
    await _db.collection('groceries').doc(id).delete();
  }

  Future<void> toggleStatus(String id, bool status) async {
    await _db.collection('groceries').doc(id).update({
      'isDone': status,
    });
  }
}
