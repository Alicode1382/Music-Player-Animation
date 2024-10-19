import 'package:flutter/material.dart';

class PlayAndPauseButton extends StatelessWidget {
  final void Function() onPressed;
  final bool playStatus;
  const PlayAndPauseButton(
      {super.key, required this.onPressed, this.playStatus = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xffEC2947), Color(0xffD2058F)],
            center: Alignment.center,
          ),
          shape: BoxShape.circle),
      child: IconButton(
          onPressed: onPressed,
          icon: Icon(playStatus ? Icons.pause : Icons.play_arrow,
              size: 60, color: Colors.white)),
    );
  }
}
