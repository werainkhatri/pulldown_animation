import 'dart:ui';

class Constants {
  static const String successUrl = 'https://api.mocklets.com/p68348/success_case';
  static const String failureUrl = 'https://api.mocklets.com/p68348/failure_case';

  static const String logoName = 'assets/logo.png';

  static const Color backgroundColor = Color.fromARGB(255, 33, 36, 38);
  static const Color accentColor = Color.fromARGB(255, 60, 150, 160);

  static const double idlePuckDistance = 20;
  static const double pullDownDistance = 300;
  static const double textTranslationDistance = -100;
  static const double circleTranslationDistance = logoSize + 32.0;
  static const double logoSize = 100;
  static const double idleScale = 20;
  static const double logoBorderWidth = 3;

  static const Duration idleDuration = Duration(milliseconds: 1500);
  static const Duration successDuration = Duration(milliseconds: 1000);
  static const Duration loadingDuration = Duration(milliseconds: 1000);
}
