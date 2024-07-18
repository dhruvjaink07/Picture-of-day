import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picture_of_day/controllers/apod_controller.dart';
import 'package:picture_of_day/data/apod_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static const platform = const MethodChannel("toast.flutter.io/toast");

  late Future<List<ApodModel>> _apodFuture;
  final APODController _apodController = APODController();

  @override
  void initState() {
    super.initState();
    _apodFuture = _apodController.getApodData(1);
  }

  void refreshData(){
    setState(() {
      _apodFuture = _apodController.getApodData(1);
    });
    showToast();
  }
  void showToast(){
    platform.invokeMethod("showToast");
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
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
        ),
        floatingActionButton: FloatingActionButton(onPressed: refreshData,child: const Icon(Icons.refresh,color: Colors.black,),),
      ),
    );
  }
}

class ApodCard extends StatelessWidget {
  final ApodModel apodModel;

  const ApodCard({super.key, required this.apodModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildImage(apodModel.hdurl),
          const SizedBox(height: 10),
          Text(apodModel.title,style: const TextStyle(fontSize: 20),),
          // const SizedBox(height: 10),
          Text(apodModel.copyright,style: const TextStyle(fontSize: 18),),
          const SizedBox(height: 10),
          Text("Explanation: ${apodModel.explanation}"),
          const SizedBox(height: 20,)
        ],
      ),
    );
  }

  Widget _buildImage(String? url) {
    if (url != null && url.isNotEmpty && Uri.tryParse(url)?.hasAbsolutePath == true) {
      return InteractiveViewer(
        maxScale: 5.0,
        child: CachedNetworkImage(
          imageUrl: url,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      );
    } else {
      return Image.asset('assets/default_image.png'); // Provide your own default image asset path
    }
  }
}
