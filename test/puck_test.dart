import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pulldown_animation/constants.dart';
import 'package:pulldown_animation/widgets/pull_down_puck.dart';

void main() {
  testWidgets('Idle animation works as expected', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PullDownPuck(
          onDragComplete: () async => true,
          dragDistance: Constants.pullDownDistance,
        ),
      ),
    );

    double yCoord = tester.getCenter(find.byType(Image)).dy;

    // Down animation
    for (int i = 0; i < 5; i++) {
      await tester.pump(Constants.idleDuration ~/ 5);
      double newYCoord = tester.getCenter(find.byType(Image)).dy;
      expect(newYCoord, greaterThan(yCoord));
      yCoord = newYCoord;
    }

    // Up animation
    for (int i = 0; i < 5; i++) {
      await tester.pump(Constants.idleDuration ~/ 5);
      double newYCoord = tester.getCenter(find.byType(Image)).dy;
      expect(newYCoord, lessThan(yCoord));
      yCoord = newYCoord;
    }
  });

  testWidgets('Idle animation stops onTapDown and resumes onTapUp', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PullDownPuck(
          onDragComplete: () async => true,
          dragDistance: Constants.pullDownDistance,
        ),
      ),
    );

    // down animation
    await tester.pump(Constants.idleDuration);
    double yCoord = tester.getCenter(find.byType(Image)).dy;

    // onTapDown
    TestGesture gesture = await tester.startGesture(tester.getCenter(find.byType(Image)));
    await tester.pump();

    // should change nothing
    await tester.pump(Constants.idleDuration);
    expect(tester.getCenter(find.byType(Image)).dy, equals(yCoord));

    // onTapUp
    await gesture.up();
    await tester.pump();
    // up animation
    await tester.pump(Constants.idleDuration);

    expect(tester.getCenter(find.byType(Image)).dy, lessThan(yCoord));
  });

  testWidgets('Drag behavior works as expected', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PullDownPuck(
          onDragComplete: () async => true,
          dragDistance: Constants.pullDownDistance,
        ),
      ),
    );

    double yCoord = tester.getCenter(find.byType(Image)).dy;
    // Tap down
    TestGesture gesture = await tester.startGesture(tester.getCenter(find.byType(Image)));
    await tester.pump();

    // initiate drag intent
    await gesture.moveBy(const Offset(0.0, 20.0));
    await tester.pump();

    // Drag down
    for (int i = 1; i <= 5; i++) {
      await gesture.moveBy(const Offset(0.0, Constants.pullDownDistance / 5));
      await tester.pump();
      expect(tester.getCenter(find.byType(Image)).dy,
          equals(yCoord + Constants.pullDownDistance * i / 5));
    }

    // Tap up - goes back up
    await gesture.up();
    await tester.pump();
    expect(tester.getCenter(find.byType(Image)).dy, equals(yCoord));
  });

  testWidgets('Does not leave bounds', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PullDownPuck(
          onDragComplete: () async => true,
          dragDistance: Constants.pullDownDistance,
        ),
      ),
    );

    double yCoord = tester.getCenter(find.byType(Image)).dy;
    // Tap down
    TestGesture gesture = await tester.startGesture(tester.getCenter(find.byType(Image)));
    await tester.pump();

    // initiate drag intent
    await gesture.moveBy(const Offset(0.0, 20.0));
    await tester.pump();

    // moves to 50 below the limit
    await gesture.moveBy(const Offset(0.0, Constants.pullDownDistance + 50));
    await tester.pump();
    expect(tester.getCenter(find.byType(Image)).dy, equals(yCoord + Constants.pullDownDistance));

    // moves to 50 above the limit
    await gesture.moveBy(const Offset(0.0, -Constants.pullDownDistance - 50 - 50));
    await tester.pump();
    expect(tester.getCenter(find.byType(Image)).dy, equals(yCoord));
  });

  testWidgets('Disappears when drag completes', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PullDownPuck(
          onDragComplete: () async => true,
          dragDistance: Constants.pullDownDistance,
        ),
      ),
    );

    TestGesture gesture = await tester.startGesture(tester.getCenter(find.byType(Image)));
    await tester.pump();

    // initiate drag intent
    await gesture.moveBy(const Offset(0.0, 20.0));
    await tester.pump();

    // drag to completion
    await gesture.moveBy(const Offset(0.0, Constants.pullDownDistance));
    await tester.pump();

    await gesture.up();
    await tester.pump();

    expect(find.byType(Image), findsNothing);
  });
}
