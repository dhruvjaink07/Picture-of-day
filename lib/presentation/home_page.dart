import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:picture_of_day/controllers/apod_controller.dart';
import 'package:picture_of_day/data/apod_model.dart';
import 'package:picture_of_day/presentation/widgets/apodDisplayCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<List<ApodModel>> _apodFuture;
  bool isOnline = true;
  final APODController _apodController = APODController();

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
    _apodFuture = _apodController.getApodData(1);
  }

  void refreshData() {
    isDeviceConnected();
    setState(() {
      _apodFuture = _apodController.getApodData(1);
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Astronomy Picture of The Day"),
          actions:[
            
          ]
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isOnline
              ? GestureDetector(
                
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
                            return ApodCard(apodModel: apodList[index]);
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
        floatingActionButton: FloatingActionButton(
          onPressed: refreshData,
          child: const Icon(
            Icons.refresh,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
