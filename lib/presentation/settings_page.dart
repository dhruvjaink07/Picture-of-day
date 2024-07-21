import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:picture_of_day/data/saved_apod_model.dart';
import 'package:picture_of_day/presentation/home_page.dart';
import 'package:picture_of_day/presentation/widgets/drawer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  late Box<SavedApodModel> box;

  @override
  void initState() {
    box = Hive.box<SavedApodModel>("saved");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: const MenuDrawer(
        pageName: "Settings",
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              key.currentState!.openDrawer();
            },
            icon: const Icon(Icons.menu)),
        title: const Text("Settings"),
      ),
      body: WillPopScope(
        onWillPop: ()async{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomePage()));
          return true;
        },
        child: Column(
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Delete Saved APODs? "),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Sure, want to delete all saved APODs?"),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      box.clear();
                                      Navigator.pop(context); // Close the dialog after clearing the box
                                    },
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
