import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Войти', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF007AFF)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(color: Color(0xFFE9E9EB), height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              cursorColor: Color(0xFF007AFF),
              decoration: InputDecoration(
                labelText: 'Логин',
                filled: true,
                fillColor: Color(0xFFE9E9EB),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.all(16),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              cursorColor: Color(0xFF007AFF),
              decoration: InputDecoration(
                labelText: 'Пароль',
                filled: true,
                fillColor: Color(0xFFE9E9EB),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.all(16),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              obscureText: true,
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF007AFF),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Продолжить'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Нажимая на кнопку, вы соглашаетесь с политикой конфиденциальности и обработки персональных данных, а также принимаете пользовательское соглашение',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Center(
              child: Image.asset(
                'assets/login_img.png',
                width: 400,
                height: 300,
              ),
            ),
            SizedBox(height: 25),
            Center(
              child: SvgPicture.asset(
                'assets/logo2.svg',
                width: 100,
                height: 50,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
