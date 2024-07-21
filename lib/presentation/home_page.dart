import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:picture_of_day/controllers/apod_controller.dart';
import 'package:picture_of_day/data/apod_model.dart';
import 'package:picture_of_day/data/saved_apod_model.dart';
import 'package:picture_of_day/presentation/widgets/apodCardShimmer.dart';
import 'package:picture_of_day/presentation/widgets/apodDisplayCard.dart';
import 'package:picture_of_day/presentation/widgets/drawer.dart';
import 'package:picture_of_day/presentation/widgets/toast.dart';
import 'package:shimmer/shimmer.dart';

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
  late Box<SavedApodModel> box;

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
    iconData = Icons.bookmark_add;
    box = Hive.box<SavedApodModel>('saved');
    _apodFuture = _apodController.getApodData(1);
  }

  void refreshData() {
    isDeviceConnected();
    setState(() {
      _apodFuture = _apodController.getApodData(1);
    });
    // Toast.showToast("Data Refreshed");
  }

  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: const MenuDrawer(pageName: "Home"),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            key.currentState!.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        title: const Text("Astronomy Picture of The Day"),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isOnline
              ? FutureBuilder<List<ApodModel>>(
                  future: _apodFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.white,
                        child: const ApodCardShimmer(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<ApodModel> apodList = snapshot.data!;
                      return ListView.builder(
                        itemCount: apodList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onPanUpdate: (details) {
                              if (details.delta.dx > 0) {
                                box.add(SavedApodModel(
                                  copyright: apodList[index].copyright,
                                  date: apodList[index].date,
                                  explanation: apodList[index].explanation,
                                  hdurl: apodList[index].hdurl,
                                  mediaType: apodList[index].mediaType,
                                  title: apodList[index].title,
                                  url: apodList[index].url,
                                ));
                                Toast.showToast("Saved To Collections");
                              } else if (details.delta.dx < 0) {
                                refreshData();
                              }
                            },
                            child: ApodCard(apodModel: apodList[index]),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('No data available'));
                    }
                  },
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off),
                      Text("No Internet Connection! Try Again Later"),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}



