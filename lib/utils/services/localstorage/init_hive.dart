import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'keys.dart';

Future initHive() async {
  await Hive.initFlutter();
  // Get the application documents directory
  final dir = await getApplicationDocumentsDirectory();
  // Check if the directory exists, if not, create it
  if (!await Directory(dir.path).exists()) {
    await Directory(dir.path).create(recursive: true);
  }
  Hive.init(dir.path);
  await Hive.openBox(Keys.hiveinit);
}
