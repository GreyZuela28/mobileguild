import 'package:flutter/material.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/admin/admin_users_page.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/admin/admin_homescreen_page.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/admin/admin_notification_page.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/admin/admin_setting_page.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageMainPageState();
}

class _AdminMainPageMainPageState extends State<AdminMainPage> {
  int index = 0;
  final screens = [
    const AdminHomeScreenPage(),
    const AdminNotificationPage(),
    const AdminUsersPage(),
    const AdminSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue.shade100,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: NavigationBar(
          elevation: 10,
          height: 60,
          backgroundColor: Colors.blueGrey,
          selectedIndex: index,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          animationDuration: const Duration(seconds: 1),
          onDestinationSelected: (index) {
            setState(() {
              this.index = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_filled),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined),
              selectedIcon: Icon(Icons.notifications_active),
              label: "Notification",
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people),
              label: "Users",
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
