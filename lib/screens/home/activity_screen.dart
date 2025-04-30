import 'package:flutter/material.dart';
import 'profile.dart';
import 'new_activity.dart';
import '../../database/activity_details_screen.dart'; // Добавьте этот импорт
import '../../database/database_helper.dart';
import 'dart:convert'; // Для работы с JSON

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _selectedIndex = 0;
  bool _showActivities = false;
  int _selectedTab = 0;
  int _startButtonPressCount = 0;

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _myActivities = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final activities = await _databaseHelper.getActivities();
    setState(() {
      _myActivities = activities;
    });
  }

  void _handleActivityUpdated(Map<String, dynamic> updatedActivity) {
    setState(() {
      _myActivities =
          _myActivities
              .map(
                (activity) =>
                    activity['id'] == updatedActivity['id']
                        ? updatedActivity
                        : activity,
              )
              .toList();
    });
  }

  List<Map<String, dynamic>> _groupActivities(
    List<Map<String, dynamic>> activities,
  ) {
    final List<Map<String, dynamic>> grouped = [];
    String? currentDate;

    for (final activity in activities) {
      final date = activity['start_time'].split('T')[0];
      if (date != currentDate) {
        grouped.add({'date': date, 'isHeader': true});
        currentDate = date;
      }
      grouped.add(activity);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedMyActivities = _groupActivities(_myActivities);

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
                _selectedTab == 0 ? groupedMyActivities : [],
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
            onTap: () async {
              final updatedActivity = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ActivityDetailsScreen(
                        activity: item,
                        onActivityUpdated: _handleActivityUpdated,
                      ),
                ),
              );
              if (updatedActivity != null) {
                _handleActivityUpdated(updatedActivity);
              }
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
                  Text(
                    item['distance'] ?? 'Нет данных',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['time'] ?? 'Нет данных',
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
                            item['activity_type'] ?? 'Нет данных',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        item['ago'] ?? 'Нет данных',
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
