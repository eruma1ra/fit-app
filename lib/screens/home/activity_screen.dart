import 'package:flutter/material.dart';
import 'profile.dart';
import 'new_activity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF007AFF)),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      home: const ActivityScreen(),
    );
  }
}

class ActivityDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> activity;

  const ActivityDetailsScreen({super.key, required this.activity});

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _commentController.text = widget.activity['comment'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: const Color(0xFF007AFF),
          onPressed: () {
            widget.activity['comment'] = _commentController.text;
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          widget.activity['type'],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.activity['distance'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.activity['ago'],
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.activity['time'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Старт ${widget.activity['startTime']} · Финиш ${widget.activity['endTime']}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
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
                        widget.activity['type'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.activity['ago'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _commentController,
                    style: const TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Комментарий',
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE9E9EB), width: 1.0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon(0, 'Активности'),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(1, 'Профиль'),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            } else {
              setState(() {
                _selectedIndex = index;
              });
            }
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

  Widget _buildNavIcon(int index, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  _selectedIndex == index
                      ? const Color(0xFF007AFF)
                      : const Color(0xFFE9E9EB),
              width: 2,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color:
                _selectedIndex == index ? const Color(0xFF007AFF) : Colors.grey,
          ),
        ),
      ],
    );
  }
}

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _selectedIndex = 0;
  bool _showActivities = false;
  int _selectedTab = 0;
  int _startButtonPressCount = 0; // Переменная для отслеживания нажатий

  final List<Map<String, dynamic>> _myActivities = [
    {
      'distance': '14.32 км',
      'time': '1 ч 42 мин',
      'type': 'Велосипед',
      'ago': '14 часов назад',
      'date': 'Сегодня',
      'startTime': '14:49',
      'endTime': '16:31',
      'isHeader': false,
      'comment': '',
    },
    {
      'distance': '8.15 км',
      'time': '1 час 12 минут',
      'type': 'Бег',
      'ago': '1 день назад',
      'date': 'Вчера',
      'startTime': '09:15',
      'endTime': '10:27',
      'isHeader': false,
      'comment': '',
    },
    {
      'distance': '5.43 км',
      'time': '45 минут',
      'type': 'Ходьба',
      'ago': '1 день назад',
      'date': 'Вчера',
      'startTime': '18:30',
      'endTime': '19:15',
      'isHeader': false,
      'comment': '',
    },
  ];

  final List<Map<String, dynamic>> _usersActivities = [
    {
      'distance': '12.78 км',
      'time': '2 часа 5 минут',
      'type': 'Велосипед',
      'ago': '2 дня назад',
      'date': '2 дня назад',
      'startTime': '15:20',
      'endTime': '17:25',
      'isHeader': false,
      'comment': '',
      'user': 'Иван Иванов',
    },
    {
      'distance': '10.5 км',
      'time': '1 час 30 минут',
      'type': 'Велосипед',
      'ago': '3 дня назад',
      'date': '3 дня назад',
      'startTime': '12:00',
      'endTime': '13:30',
      'isHeader': false,
      'comment': '',
      'user': 'Алексей Смирнов',
    },
  ];

  List<Map<String, dynamic>> _groupActivities(
    List<Map<String, dynamic>> activities,
  ) {
    final List<Map<String, dynamic>> grouped = [];
    String? currentDate;

    for (final activity in activities) {
      if (activity['date'] != currentDate) {
        grouped.add({'date': activity['date'], 'isHeader': true});
        currentDate = activity['date'];
      }
      grouped.add(activity);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedMyActivities = _groupActivities(_myActivities);
    final groupedUsersActivities = _groupActivities(_usersActivities);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: _showActivities ? null : const Text('Активности'),
        bottom:
            _showActivities
                ? PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTabButton(0, 'Моя'),
                        const SizedBox(width: 24),
                        _buildTabButton(1, 'Пользователей'),
                      ],
                    ),
                  ),
                )
                : null,
      ),
      body: Stack(
        children: [
          _showActivities
              ? _buildActivitiesList(
                _selectedTab == 0
                    ? groupedMyActivities
                    : groupedUsersActivities,
              )
              : _buildInitialContent(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildStartButton(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTabButton(int index, String text) {
    return TextButton(
      onPressed: () => setState(() => _selectedTab = index),
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: Size.zero,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color:
                  _selectedTab == index ? Colors.black : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: text.length * 10.0,
            decoration: BoxDecoration(
              color:
                  _selectedTab == index
                      ? const Color(0xFF007AFF)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Время потренить',
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
    );
  }

  Widget _buildActivitiesList(List<Map<String, dynamic>> activities) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final item = activities[index];

        if (item['isHeader'] == true) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              item['date'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        } else {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivityDetailsScreen(activity: item),
                ),
              );
            },
            child: Container(
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
                  if (_selectedTab == 1)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        item['user'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Text(
                    item['distance'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['time'],
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
                            item['type'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        item['ago'],
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
          );
        }
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE9E9EB), width: 1.0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon(0, 'Активности'),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(1, 'Профиль'),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            } else {
              setState(() {
                _selectedIndex = index;
              });
            }
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

  Widget _buildNavIcon(int index, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  _selectedIndex == index
                      ? const Color(0xFF007AFF)
                      : const Color(0xFFE9E9EB),
              width: 2,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color:
                _selectedIndex == index ? const Color(0xFF007AFF) : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (_startButtonPressCount == 0) {
              _showActivities = true;
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewActivityScreen()),
              );
            }
            _startButtonPressCount++;
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
    );
  }
}
