import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:flutter/material.dart';
class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void logout() {
    final _authService = AuthService();
    _authService.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  DrawerHeader(
                    child: Icon(
                      Icons.message,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  ListTile(
                    horizontalTitleGap: 10,
                    leading: Icon(
                      Icons.home,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text("Home", style: TextStyle(letterSpacing: 10)),
                    onTap: () {
                      // pop drawer and return to home page
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    horizontalTitleGap: 10,
                    leading: Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text("Settings", style: TextStyle(letterSpacing: 5)),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                  ),
                ],
              ),
              ListTile(
                horizontalTitleGap: 10,

                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text("Logout", style: TextStyle(letterSpacing: 5),),
              onTap: logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
