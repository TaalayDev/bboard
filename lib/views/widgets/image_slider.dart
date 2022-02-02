import 'package:bboard/views/widgets/app_carousel.dart';
import 'package:flutter/material.dart';

class ImagesSlider extends StatelessWidget {
  const ImagesSlider({
    Key? key,
    required this.images,
    this.heroTag,
  }) : super(key: key);

  final String? heroTag;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '$heroTag',
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 350,
            child: AppCarousel(images),
          ),
        ],
      ),
    );
  }
}
