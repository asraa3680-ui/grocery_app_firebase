import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grocery_item.dart';

class GroceryProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<GroceryItem> _items = [];

  // للحصول على قائمة العناصر الحالية
  List<GroceryItem> get items => _items;

  // 1. جلب البيانات من الفايربيس وتحويلها من JSON إلى Objects
  void fetchItems() {
    _db.collection('groceries').snapshots().listen((snapshot) {
      _items = snapshot.docs.map((doc) {
        return GroceryItem.fromJson(doc.data(), doc.id);
      }).toList();
      notifyListeners(); // لتحديث الواجهة فوراً
    });
  }

  // 2. إضافة عنصر جديد باستخدام toJson
  Future<void> addItem(String name) async {
    final newItem = GroceryItem(id: '', name: name);
    await _db.collection('groceries').add(newItem.toJson());
  }

  // 3. تحديث اسم العنصر (دالة التعديل المطلوبة) ✅
  Future<void> updateItem(String id, String newName) async {
    try {
      await _db.collection('groceries').doc(id).update({
        'name': newName,
      });
    } catch (e) {
      print("Error updating item: $e");
    }
  }

  // 4. حذف عنصر
  Future<void> deleteItem(String id) async {
    await _db.collection('groceries').doc(id).delete();
  }

  // 5. تحديث الحالة (تم الشراء أم لا)
  Future<void> toggleStatus(String id, bool status) async {
    await _db.collection('groceries').doc(id).update({
      'isDone': status,
    });
  }
}