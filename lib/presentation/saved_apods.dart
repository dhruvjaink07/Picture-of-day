import 'package:flutter/material.dart';
import 'package:picture_of_day/data/apod_model.dart';
import 'package:picture_of_day/presentation/home_page.dart';
import 'package:picture_of_day/presentation/widgets/drawer.dart';
import 'package:hive/hive.dart';
import 'package:picture_of_day/data/saved_apod_model.dart';
import 'package:picture_of_day/presentation/widgets/apodDisplayCard.dart';

class SavedApods extends StatefulWidget {
  const SavedApods({super.key});

  @override
  State<SavedApods> createState() => _SavedApodsState();
}

class _SavedApodsState extends State<SavedApods> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  late Box<SavedApodModel> box;
  late List<SavedApodModel> savedApodList;

  @override
  void initState() {
    super.initState();
    // Open the Hive box and fetch saved APOD data
    box = Hive.box<SavedApodModel>("saved");
    savedApodList = box.values.toList().toSet().toList().reversed.toList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: const MenuDrawer(pageName: "collection"),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            key.currentState!.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        title: const Text("Collection"),
      ),
      body: WillPopScope(
        onWillPop: () async{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomePage()));
          return true;
        },
        child: savedApodList.isNotEmpty
            ? ListView.builder(
        
                itemCount: savedApodList.length,
                itemBuilder: (context, index) {
                  return ApodCard(apodModel: savedApodList[index].toApodModel());
                },
              )
            : const Center(child: Text("No saved APODs available")),
      ),
    );
  }
}

extension on SavedApodModel {
  ApodModel toApodModel() {
    return ApodModel(
      copyright: this.copyright,
      date: this.date,
      explanation: this.explanation,
      hdurl: this.hdurl,
      mediaType: this.mediaType,
      title: this.title,
      url: this.url,
    );
  }
}
