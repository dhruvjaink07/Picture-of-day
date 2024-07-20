import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:picture_of_day/controllers/apod_controller.dart';
import 'package:picture_of_day/data/apod_model.dart';
import 'package:picture_of_day/data/saved_apod_model.dart';
import 'package:picture_of_day/presentation/widgets/apodDisplayCard.dart';
import 'package:picture_of_day/presentation/widgets/drawer.dart';
import 'package:picture_of_day/presentation/widgets/toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  late Future<List<ApodModel>> _apodFuture;
  bool isOnline = true;
  late IconData iconData;
  final APODController _apodController = APODController();
  Box box = Hive.box('saved');
  Future<void> isDeviceConnected() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    setState(() {
      isOnline = isConnected;
    });
  }

  @override
  void initState() {
    super.initState();
    isDeviceConnected();
    iconData= Icons.bookmark_add;
    _apodFuture = _apodController.getApodData(1);
  }

  void refreshData() {
    isDeviceConnected();
    setState(() {
      _apodFuture = _apodController.getApodData(1);
    });
    Toast.showToast("Data Refreshed");
  }
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: key,
        drawer: MenuDrawer(pageName: "Home",),
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            key.currentState!.openDrawer();
          }, icon: const Icon(Icons.menu)),
          title: const Text("Astronomy Picture of The Day"),
          actions:[
            GestureDetector(
              onTap: (){
                setState(() {
                  iconData = Icons.bookmark;
                });
              },
              child: Icon(iconData)),
              const SizedBox(width: 5,)
          ]
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width ,
          child: isOnline
              ? GestureDetector(
                onPanUpdate: (details){
                  if(details.delta.dx < 0){
                    refreshData();
                  }
                },
                child: FutureBuilder<List<ApodModel>>(
                    future: _apodFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        List<ApodModel> apodList = snapshot.data!;
                        return ListView.builder(
                          itemCount: apodList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onPanUpdate: (details){
                                if(details.delta.dx >0){
                                  box.add(SavedApodModel(copyright: apodList[0].copyright, date: apodList[0].date, explanation: apodList[0].explanation, hdurl: apodList[0].hdurl, mediaType: apodList[0].mediaType, title: apodList[0].title, url: apodList[0].url));
                                  Toast.showToast("Saved To Collections");
                                }
                              },
                              child: ApodCard(apodModel: apodList[index]));
                          },
                        );
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  ),
              )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off),
                      Text("No Internet Connection! Try Again Later")
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
