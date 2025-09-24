class BannerModel {
  String index;
  String url;
  String imageUrl;

  BannerModel({
    required this.index,
    required this.url,
    required this.imageUrl,
  });

  // Factory method to create an AddressModel from JSON
  factory BannerModel.fromJson(json) {
    return BannerModel(
      index: json['index'] as String,
      url: json['url'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  // Method to convert an
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'url': url,
      'imageUrl': imageUrl,
    };
  }
}
