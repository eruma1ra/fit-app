import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:async';
import '../../database/database_helper.dart';

class NewActivityScreen extends StatefulWidget {
  final Function()? onActivityAdded;

  const NewActivityScreen({this.onActivityAdded});

  @override
  _NewActivityScreenState createState() => _NewActivityScreenState();
}

class _NewActivityScreenState extends State<NewActivityScreen> {
  String _selectedActivity = 'Велосипед';
  bool _isActivityStarted = false;
  bool _isActivityPaused = false;
  final List<String> _activities = ['Велосипед', 'Бег', 'Шаг'];

  double _distanceTraveled = 0.0;
  Duration _timeElapsed = Duration.zero;
  Timer? _timer;
  DateTime? _activityStartTime;

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final Random _random = Random();

  IconData _getActivityIcon(String activity) {
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startActivity() {
    setState(() {
      _isActivityStarted = true;
      _isActivityPaused = false;
      _activityStartTime = DateTime.now();
      _distanceTraveled = 0.0;
      _timeElapsed = Duration.zero;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isActivityPaused) {
        setState(() {
          _timeElapsed += Duration(seconds: 1);
          _distanceTraveled += _random.nextDouble() * 0.1;
        });
      }
    });
  }

  void _pauseActivity() {
    setState(() {
      _isActivityPaused = true;
    });
  }

  void _resumeActivity() {
    setState(() {
      _isActivityPaused = false;
    });
  }

  Future<void> _stopActivity() async {
    _timer?.cancel();

    final endTime = DateTime.now();
    final coordinates = _generateRandomCoordinates();
    final coordinatesJson = jsonEncode(coordinates);

    try {
      await _databaseHelper.insertActivity({
        'activity_type': _selectedActivity,
        'start_time': _activityStartTime!.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'distance': _distanceTraveled.toStringAsFixed(2),
        'time': '${_timeElapsed.inMinutes} мин',
        'coordinates': coordinatesJson,
      });

      if (widget.onActivityAdded != null) {
        widget.onActivityAdded!();
      }

      Navigator.of(context).pop();
    } catch (e) {
      print('Error inserting activity: $e'); // Логирование ошибки
    }
  }

  List<Map<String, double>> _generateRandomCoordinates() {
    final coordinates = <Map<String, double>>[];
    final baseLat = 55.7558;
    final baseLon = 37.6176;

    for (int i = 0; i < 10; i++) {
      coordinates.add({
        'lat': baseLat + _random.nextDouble() / 100,
        'lon': baseLon + _random.nextDouble() / 100,
      });
    }

    return coordinates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back, color: Color(0xFF007AFF)),
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
          Container(
            color: Colors.grey[200],
            child: Image.asset(
              'assets/map.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildActivityControlPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityControlPanel() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _isActivityStarted
              ? MediaQuery.of(context).size.height / 3.5
              : MediaQuery.of(context).size.height / 2.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: SingleChildScrollView(
        child: Column(
          children:
              _isActivityStarted
                  ? _buildActiveActivityControls()
                  : _buildActivitySelectionControls(),
        ),
      ),
    );
  }

  List<Widget> _buildActivitySelectionControls() {
    return [
      Text(
        'Погнали? :)',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      SizedBox(height: 30),
      SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _activities.length,
          itemBuilder: (context, index) {
            final activity = _activities[index];
            return _buildActivityTypeCard(activity);
          },
        ),
      ),
      SizedBox(height: 20),
      _buildStartButton(),
    ];
  }

  Widget _buildActivityTypeCard(String activity) {
    final isSelected = _selectedActivity == activity;

    return GestureDetector(
      onTap: () => setState(() => _selectedActivity = activity),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Color(0xFF007AFF) : Colors.grey[300]!,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              _getActivityIcon(activity),
              color: isSelected ? Color(0xFF007AFF) : Colors.grey,
              size: 32,
            ),
            SizedBox(width: 12),
            Text(
              activity,
              style: TextStyle(
                fontSize: 18,
                color: isSelected ? Color(0xFF007AFF) : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        onPressed: _startActivity,
        color: Color(0xFF007AFF),
        borderRadius: BorderRadius.circular(10),
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'Старт',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActiveActivityControls() {
    return [
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
          Text(
            _formatDuration(_timeElapsed),
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMetricCard(
            'Дистанция',
            '${_distanceTraveled.toStringAsFixed(2)} км',
          ),
          _buildMetricCard(
            'Скорость',
            '${_calculateSpeed().toStringAsFixed(1)} км/ч',
          ),
        ],
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isActivityPaused)
            _buildControlButton(
              icon: Icons.play_arrow,
              color: Colors.green,
              onPressed: _resumeActivity,
            )
          else
            _buildControlButton(
              icon: Icons.pause,
              color: Colors.orange,
              onPressed: _pauseActivity,
            ),
          SizedBox(width: 40),
          _buildControlButton(
            icon: Icons.stop,
            color: Colors.red,
            onPressed: _stopActivity,
          ),
        ],
      ),
    ];
  }

  Widget _buildMetricCard(String title, String value) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 36, color: color),
      ),
    );
  }

  double _calculateSpeed() {
    if (_timeElapsed.inSeconds == 0) return 0.0;
    return (_distanceTraveled / _timeElapsed.inHours);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}
