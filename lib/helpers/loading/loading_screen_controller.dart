import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenConrtoller {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;
  const LoadingScreenConrtoller({
    required this.close,
    required this.update,
  });
}
