import 'package:flutter/material.dart';

class BannerM extends StatelessWidget {
  const BannerM(
      {super.key,
      required this.image,
      required this.press,
      required this.children});

  final String image;
  final VoidCallback press;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Stack(
        children: [
          Image.asset(image),
          Container(color: const Color.fromARGB(57, 0, 0, 0)),
          ...children,
        ],
      ),
    );
  }
}
