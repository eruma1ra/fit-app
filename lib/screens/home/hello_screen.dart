import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HelloScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Логотип SVG
                  SvgPicture.asset('assets/logo.svg', width: 150, height: 150),
                  SizedBox(height: 20),
                  Text(
                    'Пожалуй лучший фитнес трекер в ДВФУ',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Созданный студентами 2-ого курса',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // Кнопка "Зарегистрироваться"
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/registration');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF007AFF),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Зарегистрироваться'),
          ),
          SizedBox(height: 20),
          // Текст "Уже есть аккаунт?"
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Text(
              'Уже есть аккаунт?',
              style: TextStyle(color: Color(0xFF007AFF)),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
