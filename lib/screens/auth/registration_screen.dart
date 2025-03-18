import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final List<String> genders = ['Мужской', 'Женский'];
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Регистрация', style: TextStyle(color: Colors.black)),
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
                labelText: 'Имя или никнейм',
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
            SizedBox(height: 20),
            TextField(
              cursorColor: Color(0xFF007AFF),
              decoration: InputDecoration(
                labelText: 'Повторите пароль',
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
            SizedBox(height: 20),
            Text('Пол', style: TextStyle(fontSize: 16, color: Colors.black87)),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            genders.map((String gender) {
                              return ListTile(
                                title: Text(gender),
                                onTap: () {
                                  setState(() {
                                    selectedGender = gender;
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            }).toList(),
                      ),
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFE9E9EB),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedGender ?? 'Выберите пол',
                      style: TextStyle(
                        color:
                            selectedGender == null ? Colors.grey : Colors.black,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Color(0xFF007AFF)),
                  ],
                ),
              ),
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
