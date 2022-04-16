import 'dart:math';

import '../constants.dart';

class AppState {
  final String title;
  final String Function() getUrl;
  const AppState(this.title, this.getUrl);

  static int failureCount = -1;

  static AppState success = AppState(
    'Success',
    () => Constants.successUrl,
  );

  static AppState failure = AppState(
    'Failure',
    () => Constants.failureUrl,
  );

  static AppState random = AppState(
    'Random',
    () => Random().nextBool() ? Constants.successUrl : Constants.failureUrl,
  );

  static AppState threeFailureSuccess = AppState(
    'Three Failures then Success',
    () {
      if (failureCount == -1) failureCount = 4;
      failureCount--;
      if (failureCount > 0) {
        return Constants.failureUrl;
      } else {
        failureCount--;
        return Constants.successUrl;
      }
    },
  );

  static List<AppState> states = <AppState>[success, failure, random, threeFailureSuccess];

  @override
  int get hashCode => title.hashCode;

  @override
  bool operator ==(Object other) {
    return other is AppState && other.title == title;
  }
}
