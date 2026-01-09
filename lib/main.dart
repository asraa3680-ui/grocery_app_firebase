import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'grocery_provider.dart';
import 'auth_service.dart'; 
import 'login_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        
        ChangeNotifierProvider(create: (_) => GroceryProvider()..fetchItems()),

        StreamProvider<User?>(
          create: (_) => AuthService().user,
          initialData: null,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),

      home: user == null ? const LoginScreen() : const GroceryListScreen(),
    );
  }
}

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة غرض جديد', textAlign: TextAlign.right),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, textAlign: TextAlign.right, decoration: const InputDecoration(labelText: 'اسم الغرض')),
            TextField(controller: _quantityController, textAlign: TextAlign.right, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الكمية')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                final qty = int.tryParse(_quantityController.text) ?? 1;
                Provider.of<GroceryProvider>(context, listen: false).addItem(_nameController.text, qty);
                _nameController.clear();
                _quantityController.clear();
                Navigator.pop(ctx);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(String id, int currentQty) {
    final controller = TextEditingController(text: currentQty.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تعديل الكمية', textAlign: TextAlign.right),
        content: TextField(controller: controller, keyboardType: TextInputType.number, textAlign: TextAlign.center),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              final newQty = int.tryParse(controller.text) ?? currentQty;
              Provider.of<GroceryProvider>(context, listen: false).updateQuantity(id, newQty);
              Navigator.pop(ctx);
            },
            child: const Text('تحديث'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groceryProvider = Provider.of<GroceryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة تسوقي الذكية'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          // زر تسجيل الخروج (مطلب أساسي في الأسبوع الثاني)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),
      body: groceryProvider.items.isEmpty
          ? const Center(child: Text('القائمة فارغة'))
          : ListView.builder(
              itemCount: groceryProvider.items.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (ctx, index) {
                final item = groceryProvider.items[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: Colors.blueAccent, child: Text('${item.quantity}', style: const TextStyle(color: Colors.white))),
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
                    subtitle: Text('${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}', textAlign: TextAlign.right),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.orange), onPressed: () => _showUpdateDialog(item.id, item.quantity)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => groceryProvider.deleteItem(item.id)),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(onPressed: _showAddDialog, backgroundColor: Colors.blueAccent, child: const Icon(Icons.add, color: Colors.white)),
    );
  }
}