### 🐞 Known Issue: Notes Not Loading on Startup

**Problem:** Notes didn't show up on app launch.

**Cause:** `fetchNotes()` was called without `await`, and `readNotes()` wasn't marked `async`. Also, `context.read()` was used too early in `initState()`.

**Fix:**
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    readNotes();
  });
}

Future<void> readNotes() async {
  await context.read<NoteDatabase>().fetchNotes();
}
```

**Result:** Notes now load properly on startup.

in note_tile: mainAxisSize:MainAxisSize.min,
