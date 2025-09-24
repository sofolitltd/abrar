import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageSection extends StatefulWidget {
  const ImageSection({super.key, required this.images});

  final List images;

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //
        Container(
          height: 340,
          width: double.infinity,
          color: Colors.blueAccent.shade100.withValues(alpha: 0.1),
          child:
              widget.images.isNotEmpty
                  ? CachedNetworkImage(
                    imageUrl: widget.images[selectedImage],
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) =>
                            const Center(child: CupertinoActivityIndicator()),
                    errorWidget:
                        (context, url, error) => Image.asset(
                          'assets/images/no_image.png',
                          fit: BoxFit.cover,
                        ),
                  )
                  : Image.asset(
                    'assets/images/no_image.png',
                    fit: BoxFit.cover,
                  ),
        ),

        if (widget.images.length > 1) ...[
          SizedBox(
            width: 200,
            child: Divider(height: 1, color: Colors.grey.shade300),
          ),
          //
          Container(
            height: 72,
            color: Colors.white,
            alignment: Alignment.center,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              separatorBuilder: (context, index) {
                return const SizedBox(width: 12);
              },
              shrinkWrap: true,
              itemCount: widget.images.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    selectedImage = index;
                    setState(() {});
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            selectedImage == index
                                ? Colors.blueAccent
                                : Colors.white,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(1, 1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: widget.images[index],
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                        errorWidget:
                            (context, url, error) =>
                                const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
