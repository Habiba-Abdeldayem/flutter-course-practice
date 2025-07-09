import 'package:flutter/material.dart';
import 'package:habits_app/models/app_settings.dart';
import 'package:habits_app/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
    ], directory: dir.path);
  }

  // Save first date of app startup (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  Future<bool?> isDarkMode() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.isDarkMode;
  }

  Future<void> setThemeMode(bool isDark) async {
    final settings = await isar.appSettings.where().findFirst();
    if (settings != null) {
      settings.isDarkMode = isDark;
      await isar.writeTxn(() => isar.appSettings.put(settings),);
    }
    notifyListeners();
  }

  final List<Habit> currentHabits = [];

  // C R E A T E - add a new habit
  Future<void> addHabit(String habitName) async {
    // create a new habit
    final newHabit = Habit()..name = habitName;

    // save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // re-read from db
    readHabits();
  }

  // R E A D - read saved habits from db
  Future<void> readHabits() async {
    // fetch all habits from db
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    // give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // update UI
    notifyListeners();
  }

  // U P D A T E - check habit on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(() async {
        // if habit is completed => add the current data to completeDays list
        if (isCompleted && !habit.completeDays.contains(DateTime.now())) {
          final today = DateTime.now();
          habit.completeDays.add(DateTime(today.year, today.month, today.day));
          await isar.habits.put(habit);
        }
        // if habit is NOT completed => remove the current date from the list
        else {
          habit.completeDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        await isar.habits.put(habit);
      });
    }
    readHabits();
  }

  // U P D A T E - edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    // find the specific habit
    final habit = await isar.habits.get(id);
    if (habit != null) {
      // update name
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }

    // re-read from db
    readHabits();
  }

  // D E L E T E - delete habit
  Future<void> deleteHabit(int id) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() => isar.habits.delete(id));
    }
    readHabits();
  }
}
