import 'package:flutter/material.dart';
import 'package:picture_of_day/presentation/widgets/drawer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
        drawer: MenuDrawer(pageName: "Settings",),
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            key.currentState!.openDrawer();
          }, icon: const Icon(Icons.menu)),
          title: const Text("Settings"),
        ),
      body: Center(child: Text("Settings"),),
    );
  }
}