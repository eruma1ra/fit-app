import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Трекер активностей',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Color(0xFF007AFF)),
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
          items: [_buildNavItem(0, 'Активности'), _buildNavItem(1, 'Профиль')],
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

  BottomNavigationBarItem _buildNavItem(int index, String title) {
    return BottomNavigationBarItem(
      icon: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          child: Column(
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
                      _selectedIndex == index
                          ? const Color(0xFF007AFF)
                          : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
      label: '',
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
  int _selectedTab = 0; // 0 - Мои активности, 1 - Пользователей

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
      'distance': '7.89 км',
      'time': '1 час 15 минут',
      'type': 'Бег',
      'ago': '2 дня назад',
      'date': '2 дня назад',
      'startTime': '07:45',
      'endTime': '09:00',
      'isHeader': false,
      'comment': '',
      'user': 'Мария Петрова',
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

  // Группируем активности по датам
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
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1, color: Color(0xFFE9E9EB)),
        ),
      ),
      body:
          _showActivities
              ? Column(
                children: [
                  // Табы для переключения между "Мои" и "Пользователей"
                  Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedTab = 0;
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor:
                                  _selectedTab == 0
                                      ? const Color(0xFF007AFF)
                                      : Colors.white,
                              shape: const RoundedRectangleBorder(),
                            ),
                            child: Text(
                              'Моя',
                              style: TextStyle(
                                color:
                                    _selectedTab == 0
                                        ? Colors.white
                                        : const Color(0xFF007AFF),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedTab = 1;
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor:
                                  _selectedTab == 1
                                      ? const Color(0xFF007AFF)
                                      : Colors.white,
                              shape: const RoundedRectangleBorder(),
                            ),
                            child: Text(
                              'Пользователей',
                              style: TextStyle(
                                color:
                                    _selectedTab == 1
                                        ? Colors.white
                                        : const Color(0xFF007AFF),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFE9E9EB)),
                  Expanded(
                    child: _buildActivitiesList(
                      _selectedTab == 0
                          ? groupedMyActivities
                          : groupedUsersActivities,
                    ),
                  ),
                ],
              )
              : _buildInitialContent(),
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

  Widget _buildActivitiesList(List<Map<String, dynamic>> activities) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final item = activities[index];

        if (item['isHeader'] == true) {
          // Заголовок с датой
          return Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              item['date'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        } else {
          // Карточка активности
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
                  if (_selectedTab == 1) // Для активностей пользователей
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
          items: [_buildNavItem(0, 'Активности'), _buildNavItem(1, 'Профиль')],
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

  BottomNavigationBarItem _buildNavItem(int index, String title) {
    return BottomNavigationBarItem(
      icon: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          child: Column(
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
                      _selectedIndex == index
                          ? const Color(0xFF007AFF)
                          : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
      label: '',
    );
  }
}
