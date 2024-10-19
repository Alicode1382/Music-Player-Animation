import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../widgets/header.dart';
import '../widgets/image_shape.dart';
import '../widgets/play_and_pause_button.dart';

class BassAnimationScreen extends StatefulWidget {
  const BassAnimationScreen({super.key});

  @override
  _BassAnimationScreenState createState() => _BassAnimationScreenState();
}

class _BassAnimationScreenState extends State<BassAnimationScreen>
    with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _colorAnimController;
  late Animation<Color?> _colorAnimation;
  bool isPlaying = false;
  late Random random = Random();
  Duration? audioDuration = Duration.zero;
  List<Widget> listDivider = [];
  final StreamController<int> streamController = StreamController<int>();
  late Stream<Duration>? possitined;
  Color containerColor = Colors.white;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 1), // Can adjust based on beat detection
    );
    _colorAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));

    _animation = Tween<double>(
      begin: 300,
      end: 300,
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _colorAnimation = ColorTween(begin: Colors.red, end: Colors.red)
        .animate(_colorAnimController);

    _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
    });

    _audioPlayer.onPositionChanged.listen((possition) {
      _position = possition;
    });
  }

  void _seekAudio(double value) {
    final position = Duration(seconds: value.toInt());
    _audioPlayer.seek(position);
  }

  Future<void> _playAudio() async {
    // Load your mp3 file
    try {
      await _audioPlayer.play(AssetSource("Fadaei - Alef.mp3"));
      audioDuration = await _audioPlayer.getDuration();

      _audioPlayer.onPositionChanged.listen((Duration p) {
        int result = 210 + random.nextInt(201);
        int randomColor = random.nextInt(9999);

        _animation = Tween<double>(
          begin: result.toDouble(),
          end: result.toDouble(),
        ).animate(_controller)
          ..addListener(() {
            setState(() {});
          });
        _colorAnimation = ColorTween(
          begin: Color(int.parse(
            '0xffff$randomColor',
          )),
          end: Color(int.parse(
            '0xffff$randomColor',
          )),
        ).animate(_colorAnimController)
          ..addListener(() {
            setState(() {});
          });
        // You can adjust this logic for more precise bass detection
        _controller.forward().then((_) {
          _controller.reverse();
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _stopAudio() {
    _audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  void _puaseAudio() {
    _audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              const Header(),
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                height: 300,
                // color: Colors.red,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          if (!isPlaying) {
                            await _playAudio();
                            setState(() {
                              isPlaying = true;
                            });
                          } else {
                            _puaseAudio();
                          }
                        },
                        child: AnimatedBuilder(
                          animation: _colorAnimation,
                          builder: (context, child) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: _animation.value,
                              height: _animation.value,
                              decoration: BoxDecoration(
                                color: _colorAnimation.value,
                                borderRadius:
                                    BorderRadius.circular(_animation.value),
                              ),
                              alignment: Alignment.center,
                            );
                          },
                        ),
                      ),
                    ),
                    const ImageShape()
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              const Text(
                'Alef',
                style: TextStyle(
                    color: Color(0xffE6E6E6),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy-ExtraBold',
                    fontSize: 35),
              ),
              const SizedBox(
                height: 13,
              ),
              const Text(
                'Fadaei [Prod.Mahdyar]',
                style: TextStyle(
                    color: Color(0xffE6E6E6),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy',
                    fontSize: 25),
              ),
              const SizedBox(
                height: 13,
              ),
              StreamBuilder<int>(
                  builder: (context, snapshotForDuration) {
                    if (snapshotForDuration.connectionState ==
                        ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Slider(
                              inactiveColor: containerColor,
                              value: _position.inSeconds
                                  .toDouble()
                                  .clamp(0.0, _duration.inSeconds.toDouble()),
                              min: 0.0,
                              max: _duration.inSeconds.toDouble(),
                              onChanged: (value) {
                                _seekAudio(value);
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _position.toString().split('.').first,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Gilroy-ExtraBold'),
                                  ),
                                  Text(
                                    _duration.toString().split('.').first,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Gilroy-ExtraBold'),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshotForDuration.hasError) {
                      return const Text('has error');
                    } else {
                      return SizedBox(
                        height: 120,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: StreamBuilder<Duration>(
                                stream: possitined,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Column(
                                      children: [
                                        Slider(
                                          inactiveColor: containerColor,
                                          value: _position.inSeconds
                                              .toDouble()
                                              .clamp(
                                                  0.0,
                                                  _duration.inSeconds
                                                      .toDouble()),
                                          min: 0.0,
                                          max: _duration.inSeconds.toDouble(),
                                          onChanged: (value) {
                                            _seekAudio(value);
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _position
                                                    .toString()
                                                    .split('.')
                                                    .first,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        'Gilroy-ExtraBold'),
                                              ),
                                              Text(
                                                _duration
                                                    .toString()
                                                    .split('.')
                                                    .first,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        'Gilroy-ExtraBold'),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                })),
                      );
                    }
                  },
                  initialData: 0,
                  stream: streamController.stream),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.shuffle,
                      color: Colors.white,
                      size: 35,
                    ),
                    const Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: 35,
                    ),
                    PlayAndPauseButton(
                      onPressed: () async {
                        if (!isPlaying) {
                          await _playAudio();
                          setState(() {
                            isPlaying = true;
                          });
                        } else {
                          _puaseAudio();
                        }
                        streamDurationForCreateTimeLine();
                        loopForSong();
                      },
                      playStatus: isPlaying,
                    ),
                    const Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: 35,
                    ),
                    const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 35,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  int calculateDurationAndCreateWidget() {
    int minutes = audioDuration!.inMinutes;
    int seconds = audioDuration!.inSeconds % 60;
    int resulte = minutes * 60 + seconds;
    return resulte;
  }

  void streamDurationForCreateTimeLine() {
    streamController.sink.add(calculateDurationAndCreateWidget());
    possitined = _audioPlayer.onPositionChanged;
  }

  void loopForSong() {
    possitined!.listen((event) {
      int seconds = event.inSeconds;
      setState(() {
        containerColor = getColorBasedOnProgress(seconds);
      });
    });
  }

  Color getColorBasedOnProgress(int seconds) {
    double progress = (seconds % 60) / 60.0;
    return Color.lerp(Colors.red, Colors.white, progress) ?? Colors.red;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();

    super.dispose();
  }
}