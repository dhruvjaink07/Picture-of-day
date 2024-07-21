import 'package:flutter/material.dart';
import 'package:picture_of_day/presentation/widgets/imageShimmer.dart';
class ApodCardShimmer extends StatelessWidget {
  const ApodCardShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [ const ImageWidgetShimmer(),
       Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: 50.0,
          color: Colors.white,
        ),
      ),
       Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: 50.0,
          color: Colors.white,
        ),
      ),
       Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: 400.0,
          color: Colors.white,
        ),
      ),
      ]
    );
  }
}