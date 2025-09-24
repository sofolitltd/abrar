import 'dart:async';

import 'package:abrar/models/banner_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<BannerModel> images;

  const ImageCarousel({super.key, required this.images});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController(initialPage: 1);
  int _currentPage = 1;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Start auto sliding images every 3 seconds
  void startAutoSlide() {
    _timer?.cancel(); // Cancel previous timer if any
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  // Handle looping to create a seamless transition
  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      if (index == widget.images.length + 1) {
        _currentPage = 1;
        _pageController.jumpToPage(1);
      } else if (index == 0) {
        _currentPage = widget.images.length;
        _pageController.jumpToPage(widget.images.length);
      }
    });
  }

  // Handle manual indicator tap
  void _onIndicatorTap(int index) {
    _timer?.cancel(); // Stop the timer temporarily
    _pageController.animateToPage(
      index + 1, // Offset due to extra first page
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    // Restart the timer after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      startAutoSlide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // Image carousel
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.black12.withValues(alpha: .05),
              width: double.infinity,
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: widget.images.length + 2,
                itemBuilder: (context, index) {
                  String imageUrl;
                  if (index == 0) {
                    imageUrl = widget.images[widget.images.length - 1].imageUrl;
                  } else if (index == widget.images.length + 1) {
                    imageUrl = widget.images[0].imageUrl;
                  } else {
                    imageUrl = widget.images[index - 1].imageUrl;
                  }

                  return CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Dots Indicator
          SizedBox(
            height: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (index) {
                return GestureDetector(
                  onTap: () => _onIndicatorTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index + 1 ? 32 : 10,
                    height: _currentPage == index + 1 ? 14 : 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                      color: _currentPage == index + 1
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
