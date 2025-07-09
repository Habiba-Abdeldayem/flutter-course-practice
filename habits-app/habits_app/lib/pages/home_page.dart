import 'package:flutter/material.dart';
import 'package:habits_app/components/habit_tile.dart';
import 'package:habits_app/components/my_drawer.dart';
import 'package:habits_app/components/my_heat_map.dart';
import 'package:habits_app/database/habit_database.dart';
import 'package:habits_app/models/habit.dart';
import 'package:habits_app/theme/theme_provider.dart';
import 'package:habits_app/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    Provider.of<HabitDatabase>(
      context,
      listen: false,
    ).readHabits(); // or use context.read for readability

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final db = context.read<HabitDatabase>();
      context.read<ThemeProvider>().initTheme(db);
    });
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textEditingController,
          decoration: const InputDecoration(hintText: "Create a new habit"),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              textEditingController.clear();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              context.read<HabitDatabase>().addHabit(
                textEditingController.text,
              );
              Navigator.pop(context);
              textEditingController.clear();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      // no need to use context.watch, as it's already used in _buildHabitList()
      // here we want to update only
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  void editHabitBox(Habit habit) {
    textEditingController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textEditingController,
          decoration: const InputDecoration(hintText: "Create a new habit"),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              textEditingController.clear();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              context.read<HabitDatabase>().updateHabitName(
                habit.id,
                textEditingController.text,
              );
              Navigator.pop(context);
              textEditingController.clear();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void deleteHabitBox(Habit habit) {
    textEditingController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Are you sure you want to delete?"),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              context.read<HabitDatabase>().deleteHabit(habit.id);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: MyDrawer(habitsDb: Provider.of<HabitDatabase>(context,listen: false),),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewHabit(),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: ListView(children: [_buildHeatMap(), _buildHabitList()]),
    );
  }

  Widget _buildHeatMap() {
    final habitDatabase = context.watch<HabitDatabase>();

    List<Habit> currentHabits = habitDatabase.currentHabits;

    // Because getFirstLaunchDate() is async — you don’t know when the result will come back.
    // So FutureBuilder watches it and builds the UI once the result is ready.
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        // once data is available -> build heatmap
        if (snapshot.hasData) {
          return MyHeatMap(
            datasets: prepHeatMapDataset(currentHabits),
            startDate: snapshot.data!,
          );
        }
        // handle case where no data is returned
        else {
          return Container();
        }
      },
    );
  }

  Widget _buildHabitList() {
    // habit db
    final habitDatabase = context.watch<HabitDatabase>();

    // current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // return list of habits UI
    return ListView.builder(
      itemCount: currentHabits.length,
      // shrinkWrap = true: Make the list only as big as its contents (not full height).
      // NeverScrollableScrollPhysics	Disables scroll for the inner list — to avoid conflicts.
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habit = currentHabits[index];

        // check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completeDays);

        return HabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
