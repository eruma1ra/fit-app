import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../database/database_helper.dart';

class ActivityDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> activity;
  final Function(Map<String, dynamic>)? onActivityUpdated;

  const ActivityDetailsScreen({
    super.key,
    required this.activity,
    this.onActivityUpdated,
  });

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Map<String, dynamic> _currentActivity;

  @override
  void initState() {
    super.initState();
    _currentActivity = Map<String, dynamic>.from(widget.activity);
    _commentController.text = _currentActivity['comment'] ?? '';
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _saveActivity() async {
    _currentActivity['comment'] = _commentController.text;

    if (_currentActivity['id'] != null) {
      await _dbHelper.updateActivity(_currentActivity);
    }

    if (widget.onActivityUpdated != null) {
      widget.onActivityUpdated!(_currentActivity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F6),
      appBar: AppBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back, color: const Color(0xFF007AFF)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _currentActivity['activity_type'] ?? 'Активность',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_currentActivity['id'] != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteActivity(context),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailItem(
                    title: 'Дистанция',
                    value: _currentActivity['distance'] ?? 'Нет данных',
                    unit: 'км',
                  ),
                  _buildDetailItem(
                    title: 'Время',
                    value: _currentActivity['time'] ?? 'Нет данных',
                    unit: '',
                  ),
                  _buildTimeRange(),
                  _buildActivityTypeRow(),
                  const SizedBox(height: 24),
                  _buildCommentField(),
                  const SizedBox(height: 20),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required String title,
    required String value,
    required String unit,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            '$value $unit',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRange() {
    final startDateTime = DateTime.parse(_currentActivity['start_time']);
    final endDateTime = DateTime.parse(_currentActivity['end_time']);
    final coordinates = _currentActivity['coordinates'] ?? [];

    final startDate =
        "${startDateTime.year}-${startDateTime.month.toString().padLeft(2, '0')}-${startDateTime.day.toString().padLeft(2, '0')}";
    final startTime =
        "${startDateTime.hour.toString().padLeft(2, '0')}:${startDateTime.minute.toString().padLeft(2, '0')}";
    final endDate =
        "${endDateTime.year}-${endDateTime.month.toString().padLeft(2, '0')}-${endDateTime.day.toString().padLeft(2, '0')}";
    final endTime =
        "${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}";

    final startInfo =
        "$startDate $startTime ${coordinates.isNotEmpty ? '${coordinates[0]['lat']},${coordinates[0]['lon']}' : ''}";
    final endInfo =
        "$endDate $endTime ${coordinates.isNotEmpty && coordinates.length > 1 ? '${coordinates[coordinates.length - 1]['lat']},${coordinates[coordinates.length - 1]['lon']}' : ''}";

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Старт', style: TextStyle(fontSize: 14, color: Colors.grey)),
          Text(startInfo, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text('Финиш', style: TextStyle(fontSize: 14, color: Colors.grey)),
          Text(endInfo, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildActivityTypeRow() {
    return Row(
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
          _currentActivity['activity_type'] ?? 'Нет данных',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const Spacer(),
        Text(
          _currentActivity['ago'] ?? 'Нет данных',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildCommentField() {
    return TextField(
      controller: _commentController,
      maxLines: 3,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: 'Добавьте комментарий...',
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      onChanged: (value) {
        _currentActivity['comment'] = value;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          await _saveActivity();
          if (widget.onActivityUpdated != null) {
            widget.onActivityUpdated!(_currentActivity);
          }
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007AFF),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Отправить',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _deleteActivity(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Удалить активность?'),
            content: const Text(
              'Вы уверены, что хотите удалить эту активность?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Удалить',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true && _currentActivity['id'] != null) {
      try {
        await _dbHelper.deleteActivity(_currentActivity['id']);
        if (widget.onActivityUpdated != null) {
          widget.onActivityUpdated!({});
        }
        Navigator.of(context).pop();
      } catch (e) {
        print('Error deleting activity in UI: $e');
      }
    }
  }
}
