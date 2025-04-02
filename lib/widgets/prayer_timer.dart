import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../l10n/app_localizations.dart';

class PrayerTimer extends StatefulWidget {
  const PrayerTimer({super.key});

  @override
  State<PrayerTimer> createState() => _PrayerTimerState();
}

class _PrayerTimerState extends State<PrayerTimer> {
  late final List<Map<String, dynamic>> _segments;
  int _currentSegment = 0;
  int _timeRemaining = 300; // 5 minutes in seconds
  bool _isRunning = false;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadBeepSound();
    _initializeSegments();
  }

  void _initializeSegments() {
    final localizations = AppLocalizations.of(context);
    _segments = [
      {
        'title': localizations.praiseTitle,
        'description': localizations.praiseDescription,
        'image': 'assets/section-images/1.praise.png',
      },
      {
        'title': localizations.waitTitle,
        'description': localizations.waitDescription,
        'image': 'assets/section-images/2.wait.png',
      },
      {
        'title': localizations.confessTitle,
        'description': localizations.confessDescription,
        'image': 'assets/section-images/3.confess.png',
      },
      {
        'title': localizations.readWordTitle,
        'description': localizations.readWordDescription,
        'image': 'assets/section-images/4.read-the-word.png',
      },
      {
        'title': localizations.askTitle,
        'description': localizations.askDescription,
        'image': 'assets/section-images/5.ask.png',
      },
      {
        'title': localizations.intercessionTitle,
        'description': localizations.intercessionDescription,
        'image': 'assets/section-images/6.intercession.png',
      },
      {
        'title': localizations.prayWordTitle,
        'description': localizations.prayWordDescription,
        'image': 'assets/section-images/7.pray-the-word.png',
      },
      {
        'title': localizations.thankTitle,
        'description': localizations.thankDescription,
        'image': 'assets/section-images/8.thanks.png',
      },
      {
        'title': localizations.singTitle,
        'description': localizations.singDescription,
        'image': 'assets/section-images/9.sing.png',
      },
      {
        'title': localizations.meditateTitle,
        'description': localizations.meditateDescription,
        'image': 'assets/section-images/10.meditate.png',
      },
      {
        'title': localizations.listenTitle,
        'description': localizations.listenDescription,
        'image': 'assets/section-images/11.listen.png',
      },
      {
        'title': localizations.praiseEndTitle,
        'description': localizations.praiseEndDescription,
        'image': 'assets/section-images/12.praise.png',
      },
    ];
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _pageController.dispose();
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
            _pageController.animateToPage(
              _currentSegment,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ).then((_) {
              _startTimer();
            });
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
      _pageController.jumpToPage(0);
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

  Widget _buildSegmentPage(int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              _segments[index]['image'] as String,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _segments[index]['title'] as String,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            _segments[index]['description'] as String,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            localizations.segmentCounter(_currentSegment + 1),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          Text(
            _formatTime(_timeRemaining),
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentSegment = index;
                  _timeRemaining = 300; // Reset to 5 minutes
                  if (_isRunning) {
                    _timer?.cancel();
                    _isRunning = false;
                  }
                });
              },
              itemCount: _segments.length,
              itemBuilder: (context, index) {
                return _buildSegmentPage(index);
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isRunning)
                ElevatedButton(
                  onPressed: _startTimer,
                  child: Text(localizations.startButton),
                )
              else
                ElevatedButton(
                  onPressed: _pauseTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: Text(localizations.stopButton),
                ),
            ],
          ),
        ],
      ),
    );
  }
} 