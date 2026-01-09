import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'grocery_item.dart';

class GroceryProvider with ChangeNotifier {
  List<GroceryItem> _items = [];
  final CollectionReference groceriesCollection =
      FirebaseFirestore.instance.collection('groceries');

  List<GroceryItem> get items => [..._items];

  
  Future<void> fetchItems() async {
    final snapshot = await groceriesCollection.orderBy('createdAt', descending: true).get();
    _items = snapshot.docs.map((doc) => GroceryItem.fromFirestore(doc)).toList();
    notifyListeners();
  }

  
  Future<void> addItem(String name, int quantity) async {
    await groceriesCollection.add({
      'name': name,
      'quantity': quantity,
      'createdAt': Timestamp.now(),
    });
    await fetchItems();
  }

  
  Future<void> deleteItem(String id) async {
    await groceriesCollection.doc(id).delete();
    await fetchItems();
  }

  
  Future<void> updateQuantity(String id, int newQuantity) async {
    await groceriesCollection.doc(id).update({'quantity': newQuantity});
    await fetchItems();
  }
}