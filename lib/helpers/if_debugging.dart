import 'package:flutter/foundation.dart' show kDebugMode;
//extension para saber si estoy en modo debug o no
extension IfDebugging on String {
  String? get ifDebugging => kDebugMode ? this : null;
}