import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'grocery_provider.dart';
import 'auth_service.dart';
import 'login_screen.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GroceryProvider>(context);
    final authService = AuthService();

    final filtered = provider.items
        .where((e) => e.name.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'بحث عن غرض...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (v) => setState(() => search = v),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authService.signOut();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: filtered.isEmpty
          ? const Center(child: Text('القائمة فارغة'))
          : ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final item = filtered[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text('الكمية: ${item.quantity}'), // متوافق مع ملف item
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => provider.deleteItem(item.id),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => _addItemDialog(context, provider),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _addItemDialog(BuildContext context, GroceryProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة غرض جديد'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                // مررنا الاسم والكمية (1) لإصلاح خطأ الـ 2 arguments
                provider.addItem(controller.text, 1); 
                Navigator.pop(context);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}