import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _selectedIndex = 0;
  bool _showActivities = false;

  final List<Map<String, dynamic>> _activities = [
    {
      'distance': '14.32 км',
      'time': '2 часа 46 минут',
      'type': 'Велосипед',
      'ago': '14 часов назад',
      'date': 'Вчера',
      'isHeader': true,
    },
    {
      'distance': '14.32 км',
      'time': '2 часа 46 минут',
      'type': 'Велосипед',
      'ago': '14 часов назад',
      'date': 'Вчера',
      'isHeader': false,
    },
    {
      'distance': '8.15 км',
      'time': '1 час 12 минут',
      'type': 'Бег',
      'ago': '1 день назад',
      'date': 'Май 2022 года',
      'isHeader': true,
    },
    {
      'distance': '5.43 км',
      'time': '45 минут',
      'type': 'Ходьба',
      'ago': '2 дня назад',
      'date': 'Май 2022 года',
      'isHeader': false,
    },
    {
      'distance': '10.27 км',
      'time': '1 час 38 минут',
      'type': 'Велосипед',
      'ago': '3 дня назад',
      'date': 'Май 2022 года',
      'isHeader': false,
    },
    {
      'distance': '7.89 км',
      'time': '1 час 5 минут',
      'type': 'Бег',
      'ago': '5 дней назад',
      'date': 'Май 2022 года',
      'isHeader': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F6),
      appBar: AppBar(
        title: const Text(
          'Активности',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE9E9EB), height: 1.0),
        ),
      ),
      body: _showActivities ? _buildActivitiesList() : _buildInitialContent(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildInitialContent() {
    return Column(
      children: [
        const Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Время погрешить',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Нажимай на кнопку ниже и начинаем трекать активность',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showActivities = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Старт', style: TextStyle(fontSize: 17)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivitiesList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < _activities.length; i++)
            if (_activities[i]['isHeader'])
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  _activities[i]['date'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _activities[i]['distance'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _activities[i]['time'],
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF007AFF),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _activities[i]['type'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _activities[i]['ago'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: const Color(0xFFE9E9EB), width: 1.0),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            _selectedIndex == 0
                                ? const Color(0xFF007AFF)
                                : const Color(0xFFE9E9EB),
                        width: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Активности',
                    style: TextStyle(
                      color:
                          _selectedIndex == 0
                              ? const Color(0xFF007AFF)
                              : Colors.grey,
                    ),
                  ),
                ],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            _selectedIndex == 1
                                ? const Color(0xFF007AFF)
                                : const Color(0xFFE9E9EB),
                        width: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Профиль',
                    style: TextStyle(
                      color:
                          _selectedIndex == 1
                              ? const Color(0xFF007AFF)
                              : Colors.grey,
                    ),
                  ),
                ],
              ),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: Colors.transparent,
          unselectedItemColor: Colors.transparent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      ),
    );
  }
}
