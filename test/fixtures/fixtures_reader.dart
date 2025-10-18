import 'dart:io';

import 'package:flutter/foundation.dart';

String fixtures(String name) {
  final file = File('test/fixtures/$name').readAsStringSync();
  if (kDebugMode) {
    print(file);
  }
  return file;
}
