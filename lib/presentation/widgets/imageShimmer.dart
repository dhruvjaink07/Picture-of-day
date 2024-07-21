import 'package:flutter/material.dart';

class ImageWidgetShimmer extends StatelessWidget {
  const ImageWidgetShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 200.0,
        color: Colors.white,
      ),
    );
  }
}
