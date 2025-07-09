import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes_app/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  // I N I T I A L I Z E - D A T A B A S E
  static Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: directory.path);
  }

  // list of notes
  final List<Note> currentNotes = [];

  // C R E A T E
  Future<void> addNote(String textFromUser) async {
    //! .. is cascade operator, a shorthand to create an object and give value to it's attributes in one line
    final newNote = Note()..text = textFromUser;
    await isar.writeTxn(() => isar.notes.put(newNote));

    // re-read from DB
    fetchNotes();
  }

  // R E A D - notes from DB
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);

    notifyListeners();
  }

  // U P D A T E - a note in DB
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  // D E L E T E - a note from DB
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
