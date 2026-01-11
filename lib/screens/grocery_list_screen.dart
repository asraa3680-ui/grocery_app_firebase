import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/grocery_provider.dart';


class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الاتصال بالبروفايدر
    final provider = Provider.of<GroceryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة التسوق الذكية'),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: provider.items.isEmpty 
          ? const Center(child: Text('القائمة فارغة، أضف شيئاً!'))
          : ListView.builder(
              itemCount: provider.items.length,
              itemBuilder: (context, index) {
                final item = provider.items[index];
                return ListTile(
                  title: Text(item.name, style: TextStyle(
                    decoration: item.isDone ? TextDecoration.lineThrough : null
                  )),
                  leading: Checkbox(
                    value: item.isDone,
                    onChanged: (val) => provider.toggleStatus(item.id, val!),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => provider.deleteItem(item.id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, provider),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, GroceryProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة منتج'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'اسم المنتج')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.addItem(controller.text);
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