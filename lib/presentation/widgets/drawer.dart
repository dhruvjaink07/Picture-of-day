import 'package:flutter/material.dart';
import 'package:picture_of_day/presentation/home_page.dart';
import 'package:picture_of_day/presentation/privacy_policy.dart';
import 'package:picture_of_day/presentation/saved_apods.dart';
import 'package:picture_of_day/presentation/settings_page.dart';

class MenuDrawer extends StatelessWidget {
  final String pageName;
  const MenuDrawer({required this.pageName});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                  child: const Text(
                "APOD",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ))),
          ListTile(
            title: Text(
              "Home",
              style: TextStyle(
                  color: (pageName == "Home") ? Colors.blue : Colors.black),
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          ListTile(
            title: Text("Saved APODs",
              style: TextStyle(
                  color: (pageName == "SavedApods") ? Colors.blue : Colors.black),),
                   onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SavedApods()));
            },
          ),
          ListTile(
            title: Text("Privacy Policy",
              style: TextStyle(
                  color: (pageName == "PP") ? Colors.blue : Colors.black),),
                   onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const PrivacyPolicy()));
            },
          ),
          const Divider(),
          ListTile(
            title: Text("Settings",
              style: TextStyle(
                  color: (pageName == "Settings") ? Colors.blue : Colors.black),),
                   onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
          ),
        ],
      ),
    );
  }
}
