class ImageModel {
  final String id;
  final String imageUrl;
  final String link;

  ImageModel({
    required this.id,
    required this.imageUrl,
    required this.link,
  });

  //from json
  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: json['id'],
        imageUrl: json['imageUrl'],
        link: json['link'],
      );

  // to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'imageUrl': imageUrl,
        'link': link,
      };
}

//
List<ImageModel> sliderImageList = [
  ImageModel(id: '1', imageUrl: 'assets/images/banner1.png', link: ''),
  ImageModel(id: '2', imageUrl: 'assets/images/banner2.png', link: ''),
  ImageModel(id: '3', imageUrl: 'assets/images/banner3.png', link: ''),
];

List<ImageModel> offerImageList = [
  ImageModel(id: '1', imageUrl: 'assets/images/cover1.png', link: ''),
  ImageModel(id: '2', imageUrl: 'assets/images/cover2.png', link: ''),
];
