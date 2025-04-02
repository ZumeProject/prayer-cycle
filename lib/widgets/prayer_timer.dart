import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PrayerTimer extends StatefulWidget {
  const PrayerTimer({super.key});

  @override
  State<PrayerTimer> createState() => _PrayerTimerState();
}

class _PrayerTimerState extends State<PrayerTimer> {
  final List<Map<String, String>> _segments = [
    {
      'title': 'PRAISE',
      'description': 'Start your prayer hour by praising the Lord. Praise Him for things that are on your mind right now. Praise Him for one special thing He has done in your life in the past week. Praise Him for His goodness to your family.',
    },
    {
      'title': 'WAIT',
      'description': 'Spend time waiting on the Lord. Be silent and let Him pull together reflections for you.',
    },
    {
      'title': 'CONFESS',
      'description': 'Ask the Holy Spirit to show you anything in your life that might be displeasing to Him. Ask Him to point out attitudes that are wrong, as well as specific acts for which you have not yet made a prayer of confession. Now confess that to the Lord so that you might be cleansed.',
    },
    {
      'title': 'READ THE WORD',
      'description': 'Spend time reading in the Psalms, in the prophets, or passages on prayer located in the New Testament.',
    },
    {
      'title': 'ASK',
      'description': 'Make requests on behalf of yourself.',
    },
    {
      'title': 'INTERCESSION',
      'description': 'Make requests on behalf of others.',
    },
    {
      'title': 'PRAY THE WORD',
      'description': 'Pray specific passages. Scriptural prayers as well as a number of Psalms lend themselves well to this purpose.',
    },
    {
      'title': 'THANK',
      'description': 'Give thanks to the Lord for the things in your life, on behalf of your family, and on behalf of your church.',
    },
    {
      'title': 'SING',
      'description': 'Sing songs of praise or worship or another hymn or spiritual song.',
    },
    {
      'title': 'MEDITATE',
      'description': 'Ask the Lord to speak to you. Have a pen and paper ready to record impressions He gives you.',
    },
    {
      'title': 'LISTEN',
      'description': 'Spend time merging the things you have read, things you have prayed and things you have sung and see how the Lord brings them all together to speak to you.',
    },
    {
      'title': 'PRAISE',
      'description': 'Praise the Lord for the time you have had to spend with Him and the impressions He has given you. Praise Him for His glorious attributes.',
    },
  ];

  int _currentSegment = 0;
  int _timeRemaining = 300; // 5 minutes in seconds
  bool _isRunning = false;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadBeepSound();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadBeepSound() async {
    await _audioPlayer.setSource(AssetSource('sounds/beep.mp3'));
  }

  void _startTimer() {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          _playBeep();
          if (_currentSegment < _segments.length - 1) {
            _currentSegment++;
            _timeRemaining = 300;
            _startTimer();
          }
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _currentSegment = 0;
      _timeRemaining = 300;
      _isRunning = false;
    });
  }

  Future<void> _playBeep() async {
    await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Segment ${_currentSegment + 1} of 12',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          Text(
            _formatTime(_timeRemaining),
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  _segments[_currentSegment]['title']!,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  _segments[_currentSegment]['description']!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isRunning)
                ElevatedButton(
                  onPressed: _startTimer,
                  child: const Text('Start'),
                )
              else
                ElevatedButton(
                  onPressed: _pauseTimer,
                  child: const Text('Pause'),
                ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _resetTimer,
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 