import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits_app/database/habit_database.dart';
import 'package:habits_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  final HabitDatabase habitsDb;
  const MyDrawer({super.key, required this.habitsDb});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Center(
        child: CupertinoSwitch(
          value: Provider.of<ThemeProvider>(context).isDarkMode,
          onChanged: (value) =>
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme(habitsDb),
        ),
      ),
    );
  }
}
