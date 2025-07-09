import 'package:isar/isar.dart';

// This line is needed to generate file
part 'note.g.dart';
// then run: dart run build_runner build
@Collection()
class Note {
  Id id = Isar.autoIncrement;
  late String text;
}
