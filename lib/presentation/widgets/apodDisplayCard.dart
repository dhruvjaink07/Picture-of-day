import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:picture_of_day/data/apod_model.dart';
import 'package:picture_of_day/presentation/widgets/toast.dart';
import 'package:screenshot/screenshot.dart';

class ApodCard extends StatefulWidget {
  final ApodModel apodModel;

  const ApodCard({super.key, required this.apodModel});

  @override
  State<ApodCard> createState() => _ApodCardState();
}

class _ApodCardState extends State<ApodCard> {
  ScreenshotController screenshotController = ScreenshotController();
  static const platform = MethodChannel('toast.flutter.io/toast');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildImage(widget.apodModel.url,widget.apodModel.title),
          const SizedBox(height: 10),
          Text(widget.apodModel.title, style: const TextStyle(fontSize: 20)),
          Text(widget.apodModel.copyright, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Text("Explanation: ${widget.apodModel.explanation}"),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildImage(String? url,String imageName) {
    if (url != null && url.isNotEmpty && Uri.tryParse(url)?.hasAbsolutePath == true) {
      return InkWell(
        onLongPress: () async {
          try {
            final image = await screenshotController.capture(delay: const Duration(milliseconds: 10));
            if (image != null) {
              final result = await ImageGallerySaver.saveImage(image,name: imageName);
              print("Screenshot saved to gallery: $result");
              Toast.showToast("Image Saved to Gallery");
            }
          } catch (e) {
            print("Error capturing screenshot: $e");
          }
        },
        child: Screenshot(
          controller: screenshotController,
          child: InteractiveViewer(
            maxScale: 5.0,
            child: CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      );
    } else {
      return Image.asset('assets/default_image.png'); // Provide your own default image asset path
    }
  }
}
