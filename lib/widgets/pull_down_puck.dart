import 'package:flutter/material.dart';

import '../constants.dart';

/// Creates a pull down widget.
///
/// Calls [onDragComplete] when the user completes the drag.
class PullDownPuck extends StatefulWidget {
  /// Called when the user drags the puck for [dragDistance] and leaves it.
  ///
  /// The puck will disappear after this is called.
  ///
  /// If this function returns true.
  final Future<bool> Function() onDragComplete;

  /// Distance for which the user can drag the puck down.
  final double dragDistance;

  const PullDownPuck({
    Key? key,
    required this.onDragComplete,
    required this.dragDistance,
  }) : super(key: key);

  @override
  _PullDownPuckState createState() => _PullDownPuckState();
}

class _PullDownPuckState extends State<PullDownPuck> with SingleTickerProviderStateMixin {
  late AnimationController _idleAnimation;
  late ValueNotifier<double> _dragNotifier;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _dragNotifier = ValueNotifier(0);
    _idleAnimation = AnimationController(
      upperBound: Constants.idlePuckDistance,
      vsync: this,
      duration: Constants.idleDuration,
    )
      ..drive(CurveTween(curve: Curves.easeInOutBack))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _idleAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onVerticalDragDown: _onTapDown,
        onVerticalDragUpdate: _dragUpdate,
        onVerticalDragEnd: _dragEnd,
        child: AnimatedBuilder(
          // responsible for drag.
          animation: _dragNotifier,
          builder: (context, child) {
            // responsible for idle animation.
            return AnimatedBuilder(
              animation: _idleAnimation,
              builder: (context, _) => Transform.translate(
                offset: Offset(0, _computeY()),
                child: child,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20.0),
            height: Constants.logoSize,
            width: Constants.logoSize,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(
                Radius.circular(Constants.logoSize / 2),
              ),
            ),
            child: Image.asset(Constants.logoName),
          ),
        ),
      ),
    );
  }

  void _onTapDown(_) {
    _dragNotifier.value = _idleAnimation.value;
    _idleAnimation.stop();
  }

  void _onTapUp([_]) {
    _idleAnimation.repeat(reverse: true);
    _dragNotifier.value = 0;
  }

  void _dragUpdate(DragUpdateDetails details) {
    _dragNotifier.value += details.delta.dy;
  }

  void _dragEnd(DragEndDetails details) {
    if (_dragNotifier.value >= widget.dragDistance) {
      widget.onDragComplete().then((bool value) {
        if (value) {
          setState(() {
            _visible = true;
          });
        }
      });
      setState(() {
        _visible = false;
      });
    }
    _onTapUp();
  }

  double _computeY() {
    if (_idleAnimation.isAnimating) {
      // idle animation.
      return _idleAnimation.value;
    } else {
      // drag.
      return _dragNotifier.value.clamp(0.0, widget.dragDistance);
    }
  }
}
