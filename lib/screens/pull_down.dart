import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/app_state.dart';
import '../widgets/circle_target.dart';
import '../widgets/pull_down_puck.dart';

class PullDownScreen extends StatefulWidget {
  final AppState state;
  const PullDownScreen({Key? key, required this.state}) : super(key: key);

  @override
  _PullDownScreenState createState() => _PullDownScreenState();
}

class _PullDownScreenState extends State<PullDownScreen> with TickerProviderStateMixin {
  bool _loading = false;
  late Animation<Color?> _arrowColor;
  late Animation<Offset> _circleOffset, _textOffset;
  late Animation<double> _cardHeight;
  late AnimationController _arrowController;
  late AnimationController _successController;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: Constants.successDuration,
    );

    _circleOffset = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(
          0.0,
          Constants.circleTranslationDistance,
        )).animate(
      CurvedAnimation(
        parent: _successController,
        curve: Curves.easeIn,
      ),
    );

    _textOffset = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(
          0.0,
          Constants.textTranslationDistance,
        )).animate(
      CurvedAnimation(
        parent: _successController,
        curve: Curves.easeOut,
      ),
    );

    _cardHeight = Tween<double>(
      begin: Constants.pullDownDistance + Constants.logoSize / 2,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.easeIn,
    ));

    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _arrowColor = ColorTween(begin: Constants.backgroundColor, end: Constants.accentColor)
        .animate(CurvedAnimation(parent: _arrowController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _successController.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Stack(
                  children: [
                    // down pointing arrow
                    Positioned(
                      bottom: Constants.pullDownDistance - Constants.logoSize / 2,
                      left: 0.0,
                      right: 0.0,
                      child: AnimatedBuilder(
                        animation: _arrowColor,
                        builder: (_, __) => RotatedBox(
                          quarterTurns: 3,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: _arrowColor.value,
                          ),
                        ),
                      ),
                    ),
                    // card
                    Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              color: Colors.white,
                              child: Container(),
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _cardHeight,
                          builder: (_, value) => SizedBox(
                            height: _cardHeight.value,
                          ),
                        ),
                      ],
                    ),
                    // success text
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      bottom: Constants.pullDownDistance,
                      child: AnimatedBuilder(
                        animation: _textOffset,
                        builder: (_, child) => Transform.translate(
                          offset: _textOffset.value,
                          child: child,
                        ),
                        child: const Text(
                          'success',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Constants.backgroundColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // loading animation
                    AnimatedBuilder(
                      animation: _circleOffset,
                      builder: (_, child) => Transform.translate(
                        offset: _circleOffset.value,
                        child: child,
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: CircleTarget(
                          size: Constants.logoSize,
                          child: Visibility(
                            visible: _loading,
                            child: const SpinKitSpinningLines(
                              color: Colors.blue,
                              duration: Constants.loadingDuration,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // pull down puck
                    Positioned(
                      bottom: Constants.pullDownDistance,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: PullDownPuck(
                          onDragComplete: onComplete,
                          dragDistance: Constants.pullDownDistance,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // called when the drag completes
  Future<bool> onComplete() async {
    setState(() {
      //
      _loading = true;
    });
    _arrowController.reset();

    late http.Response response;
    Uri uri = Uri.parse(widget.state.getUrl());
    try {
      response = await http.get(uri);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Internet connection lost.');

      setState(() {
        _loading = false;
      });
      _arrowController.repeat(reverse: true);

      return true;
    }
    if (jsonDecode(response.body)['success']) {
      _successController.forward();
    } else {
      Fluttertoast.showToast(msg: 'Error occured.');
      _arrowController.repeat(reverse: true);
    }

    setState(() {
      _loading = false;
    });

    return !jsonDecode(response.body)['success'];
  }
}
