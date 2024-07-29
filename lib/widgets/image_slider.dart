import 'dart:async';

import 'package:flutter/material.dart';

import '../model/image_model.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key, required this.images});

  final List<ImageModel> images;

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(seconds: 10),
      (Timer timer) {
        //
        if (_currentPage < widget.images.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        //
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).width < 600 ? 250 : 460,
      color: Colors.blueAccent.shade100,
      margin: const EdgeInsets.all(16),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          //
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              var id = widget.images[page].id;
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Image.asset(
                widget.images[index].imageUrl,
                fit: BoxFit.cover,
              );
            },
          ),

          //
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.images.map(
              (image) {
                int index = widget.images.indexOf(image);
                //
                return GestureDetector(
                  onTap: () {
                    _currentPage = index;
                    _pageController.animateToPage(
                      _currentPage,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                    );
                    setState(() {});
                  },
                  child: Container(
                    width: _currentPage == index ? 24 : 12,
                    // width: 24,
                    height: 12,
                    margin: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(8),
                      color: _currentPage == index
                          ? Colors.blueAccent
                          : Colors.grey,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
