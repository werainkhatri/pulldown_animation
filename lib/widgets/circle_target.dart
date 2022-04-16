import 'package:flutter/material.dart';

import '../constants.dart';

class CircleTarget extends StatelessWidget {
  final double size;
  final Widget child;
  const CircleTarget({Key? key, required this.child, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        border: Border.all(
          width: Constants.logoBorderWidth,
          color: const Color(0x559E9E9E),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(Constants.logoSize / 2)),
      ),
      child: child,
    );
  }
}
