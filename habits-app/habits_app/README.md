## 📘 What I Learned: `Provider.of` vs `context.read()` in Flutter

When using the `provider` package in Flutter, you’ll often need to access your state or data class. There are multiple ways to do that, and each serves a different purpose.

---

### 🔍 What's the Difference?

| Feature                         | `Provider.of<T>(context)`          | `context.read<T>()`                  |
|----------------------------------|------------------------------------|--------------------------------------|
| 🔁 Listens for changes?          | ✅ Yes (by default)                 | ❌ No                                 |
| 💡 Causes widget rebuild?        | ✅ Yes, if `listen: true`           | ❌ No                                 |
| 🔧 Used in...                    | `build()` or UI-related methods    | `onPressed`, `initState`, etc.       |
| 🚫 Risk of unnecessary rebuilds? | ✅ Yes, if not used carefully       | ❌ No                                 |
| 🧠 Cleaner & safer?              | ❌ Less safe outside `build()`      | ✅ Yes, especially for method calls   |

---

### ✅ Best Practices

| Use Case                                                | Recommended Method                                         |
|----------------------------------------------------------|------------------------------------------------------------|
| 🔘 Just call a method (e.g. `addHabit`)                  | `context.read<T>()` or `Provider.of<T>(context, listen: false)` |
| 👀 Want to listen to changes inside `build()`            | `context.watch<T>()` or `Consumer<T>`                      |
| 🚨 Want to avoid unwanted rebuilds in stateless widgets  | Avoid `Provider.of<T>(context)` unless `listen: false`     |

---

### 💬 Code Examples

#### ✅ Good: No rebuild, just calling a method

```dart
context.read<HabitDatabase>().addHabit("Drink Water");
```

#### ❌ Not Ideal: May cause unnecessary rebuilds

```dart
Provider.of<HabitDatabase>(context).addHabit("Drink Water");
```
#### ✅ Safe Alternative:

```dart
Provider.of<HabitDatabase>(context, listen: false).addHabit("Drink Water");
```

### 🧠 Summary

- ✅ Use `context.read<T>()` when performing actions only (e.g., calling methods).
- ✅ Use `context.watch<T>()` when your **UI should update** on changes.
- ❌ Avoid `Provider.of<T>(context)` with `listen: true` unless you're inside `build()` **and want rebuilds**.
- ✅ Use `listen: false` when you want to **avoid rebuilds** with `Provider.of`.

### 📝 ListView Properties Explained

- `shrinkWrap: true`  
  Makes the `ListView` only as big as its contents, rather than expanding to the full available height.  
  Useful when placing a `ListView` inside another scrollable widget like `Column` or `SingleChildScrollView`.

- `physics: NeverScrollableScrollPhysics()`  
  Disables scrolling for this `ListView`.  
  Often used when the parent widget is already scrollable, to prevent nested scroll conflicts.
