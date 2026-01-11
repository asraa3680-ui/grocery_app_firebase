import 'package:flutter/material.dart';
import '../auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true; // للتبديل بين تسجيل الدخول وإنشاء حساب

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'تسجيل الدخول' : 'إنشاء حساب جديد'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                if (isLogin) {
                  await AuthService().signIn(_emailController.text, _passwordController.text);
                } else {
                  await AuthService().signUp(_emailController.text, _passwordController.text);
                }
              },
              child: Text(isLogin ? 'دخول' : 'تسجيل'),
            ),
            
            // هذا هو الجزء الذي يظهر "ليس لديك حساب"
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin; // تبديل الحالة
                });
              },
              child: Text(isLogin 
                ? 'ليس لديك حساب؟ اضغط للتسجيل' 
                : 'لديك حساب بالفعل؟ سجل دخولك'),
            ),
          ],
        ),
      ),
    );
  }
}