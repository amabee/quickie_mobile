import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class InstagramStyleCarousel extends StatefulWidget {
  final List<String> images;

  const InstagramStyleCarousel({super.key, required this.images});

  @override
  _InstagramStyleCarouselState createState() => _InstagramStyleCarouselState();
}

class _InstagramStyleCarouselState extends State<InstagramStyleCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300.0,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.images.map((image) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }).toList(),
        ),
        if (widget.images.length > 1)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DotsIndicator(
              dotsCount: widget.images.length,
              position: _currentIndex,
              decorator: const DotsDecorator(
                size: Size.square(8.0),
                activeSize: Size(8.0, 8.0),
                color: Colors.grey,
                activeColor: Colors.blue,
              ),
            ),
          ),
      ],
    );
  }
}
