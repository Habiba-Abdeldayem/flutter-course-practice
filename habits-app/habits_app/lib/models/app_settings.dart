import 'package:isar/isar.dart';

// It's standard practice to include an id field when using Isar collections — even for singleton-like data (like settings).
part 'app_settings.g.dart';

@Collection()
class AppSettings {
  Id id = Isar.autoIncrement;
  DateTime? firstLaunchDate;
  bool isDarkMode = false;
}
