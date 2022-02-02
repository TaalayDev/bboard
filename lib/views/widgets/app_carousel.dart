import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide Image;

import '../../../resources/theme.dart';
import 'app_network_image.dart';

class AppCarousel extends StatefulWidget {
  final List<String> images;

  const AppCarousel(this.images, {Key? key}) : super(key: key);

  @override
  _AppCarouselState createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  int _current = 1;

  final CarouselController controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox(height: 350);

    return Stack(
      alignment: Alignment.center,
      children: [
        CarouselSlider.builder(
          itemCount: widget.images.length,
          itemBuilder: (context, index, _) {
            return InkWell(
              onTap: () {
                // AppDialogs.imageDialog(context, widget.images, initial: index);
              },
              child: AppNetworkImage(
                imageUrl: widget.images[index],
                fit: BoxFit.cover,
              ),
            );
          },
          carouselController: controller,
          options: CarouselOptions(
              viewportFraction: 1,
              aspectRatio: 2.0,
              height: 350,
              autoPlay: widget.images.length > 1,
              onPageChanged: (index, _) {
                setState(() {
                  _current = index + 1;
                });
              }),
        ),
        Positioned(
          left: 10,
          child: InkWell(
            onTap: () {
              controller.previousPage();
            },
            radius: 20,
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Icon(Icons.arrow_back_ios,
                    size: 13, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          child: InkWell(
            onTap: () {
              controller.nextPage();
            },
            radius: 20,
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Icon(Icons.arrow_forward_ios,
                    size: 13, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(4.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
            child: Row(
              children: [
                Icon(
                  Icons.camera_alt,
                  size: 13,
                  color: Theme.of(context).onPrimary,
                ),
                const SizedBox(width: 6),
                Text(
                  '$_current/${widget.images.length}',
                  style: TextStyle(color: Theme.of(context).onPrimary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
