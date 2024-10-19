import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset('assets/Images/Chevron-left.svg'),
          Row(
            children: [
              SvgPicture.asset('assets/Images/music.svg',
                  height: 20, width: 20),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'Now Playing',
                style: TextStyle(
                    color: Color(0xffE6E6E6),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy-ExtraBold',
                    fontSize: 20),
              ),
            ],
          ),
          SvgPicture.asset('assets/Images/Three-dots.svg'),
        ],
      ),
    );
  }
}
