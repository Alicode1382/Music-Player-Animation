import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SongColorChanger extends StatefulWidget {
  const SongColorChanger({super.key});

  @override
  _SongColorChangerState createState() => _SongColorChangerState();
}

class _SongColorChangerState extends State<SongColorChanger> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Stream<Duration>? _positionStream;
  List<Color> containerColors = [];
  int activeIndex = 0; // Index of the currently active container
  final int numberOfContainers = 10; // Number of containers in the row

  @override
  void initState() {
    super.initState();
    // Initialize the colors for each container as white.
    containerColors = List<Color>.filled(numberOfContainers, Colors.white);
    _positionStream = _audioPlayer.onPositionChanged;
    loopForSong();
  }

  void loopForSong() {
    _positionStream!.listen((event) {
      int seconds = event.inSeconds;
      setState(() {
        // Update the color of the active container
        containerColors[activeIndex] = _getColorBasedOnProgress(seconds);
        // Move to the next container (loop back if at the end)
        activeIndex = (activeIndex + 1) % numberOfContainers;
      });
    });
  }

  // Function to get a color based on time (interpolation)
  Color _getColorBasedOnProgress(int seconds) {
    // For example, alternate between red and blue based on the second
    return seconds % 2 == 0 ? Colors.red : Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Changing Containers'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(numberOfContainers, (index) {
            return Row(
              children: [
                Container(
                  width: 4,
                  height: 80,
                  color: containerColors[index],
                ),
                const SizedBox(width: 2),
              ],
            );
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
