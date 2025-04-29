import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NewActivityScreen extends StatefulWidget {
  @override
  _NewActivityScreenState createState() => _NewActivityScreenState();
}

class _NewActivityScreenState extends State<NewActivityScreen> {
  String _selectedActivity = 'Велосипед';
  bool _isActivityStarted = false;
  final List<String> _activities = ['Велосипед', 'Бег', 'Шаг'];
  final ScrollController _scrollController = ScrollController();

  double _distanceTraveled = 0.0; // Distance traveled in kilometers
  Duration _timeElapsed = Duration.zero; // Time elapsed

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _startActivity() {
    setState(() {
      _isActivityStarted = true;
      // Здесь можно добавить логику для начала отслеживания активности
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back, color: Color(0xFF007AFF), size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Новая активность',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Фоновое изображение карты
          Image.asset(
            'assets/map.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Белый блок с активностями
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height:
                _isActivityStarted
                    ? MediaQuery.of(context).size.height /
                        3.5 // Уменьшаем высоту
                    : MediaQuery.of(context).size.height / 2.8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (!_isActivityStarted) ...[
                      // Центрированный текст "Погнали"
                      Center(
                        child: Text(
                          'Погнали? :)',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50), // Отступ перед слайдером
                      // Горизонтальный слайдер активностей
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: _activities.length,
                          itemBuilder: (context, index) {
                            final activity = _activities[index];
                            final isSelected = _selectedActivity == activity;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedActivity = activity;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Color(0xFF007AFF)
                                            : Colors.grey[300]!,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _getIconForActivity(activity),
                                      color:
                                          isSelected
                                              ? Color(0xFF007AFF)
                                              : Colors.grey,
                                      size: 32,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      activity,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            isSelected
                                                ? Color(0xFF007AFF)
                                                : Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ), // Уменьшенный отступ перед кнопкой
                      // Широкая кнопка "Старт"
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton(
                          onPressed: _startActivity,
                          color: Color(0xFF007AFF),
                          borderRadius: BorderRadius.circular(10),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Старт',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedActivity,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          // Здесь можно добавить иконку или другой элемент
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_distanceTraveled.toStringAsFixed(2)} км',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          Text(
                            '${_timeElapsed.inMinutes} мин',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CupertinoButton(
                            onPressed: () {
                              // Логика для паузы
                            },
                            child: Icon(
                              Icons.pause_circle,
                              size: 50,
                              color: Color(0xFF007AFF),
                            ),
                          ),
                          SizedBox(width: 20),
                          CupertinoButton(
                            onPressed: () {
                              // Логика для остановки
                            },
                            child: Icon(
                              Icons.stop_circle,
                              size: 50,
                              color: Color(0xFF007AFF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForActivity(String activity) {
    switch (activity) {
      case 'Велосипед':
        return Icons.directions_bike;
      case 'Бег':
        return Icons.directions_run;
      case 'Шаг':
        return Icons.directions_walk;
      default:
        return Icons.help;
    }
  }
}
