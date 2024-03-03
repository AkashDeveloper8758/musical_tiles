import 'package:flutter/material.dart';

class BoxWidget extends StatelessWidget {
  final int x;
  final int y;
  final double width;
  final double height;
  final bool isSelected;
  final bool isHidden;
  const BoxWidget(
      {super.key,
      required this.x,
      required this.y,
      required this.width,
      this.isHidden = false,
      this.isSelected = false,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: isSelected
              ? isHidden
                  ? Colors.pink.shade300
                  : Colors.black54
              : Colors.white,
          // border: Border.all(width: 0.5, color: Colors.grey.shade300)
        ));
  }
}
