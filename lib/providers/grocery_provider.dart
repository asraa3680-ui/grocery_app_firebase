import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grocery_item.dart'; // تأكدي أن المسار صحيح

class GroceryProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<GroceryItem> _items = [];

  List<GroceryItem> get items => _items;

  // جلب البيانات بشكل لحظي (Real-time)
  void fetchItems() {
    _db.collection('groceries').snapshots().listen((snapshot) {
      _items = snapshot.docs.map((doc) => 
        GroceryItem.fromJson(doc.data(), doc.id)).toList();
      notifyListeners();
    });
  }

  // إضافة منتج جديد باستخدام الـ JSON
  Future<void> addItem(String name) async {
    final newItem = GroceryItem(id: '', name: name);
    await _db.collection('groceries').add(newItem.toJson());
  }

  // تحديث حالة المنتج (تم الشراء أم لا)
  Future<void> toggleStatus(String id, bool status) async {
    await _db.collection('groceries').doc(id).update({'isDone': status});
  }

  // حذف منتج
  Future<void> deleteItem(String id) async {
    await _db.collection('groceries').doc(id).delete();
  }
}