import 'package:flutter/material.dart';
import 'package:picture_of_day/presentation/widgets/drawer.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
        drawer: MenuDrawer(pageName: "PP",),
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            key.currentState!.openDrawer();
          }, icon: const Icon(Icons.menu)),
          title: const Text("Privacy Policy"),
        ),
      body: Center(child: Text("Privacy Policy"),),
    );
  }
}