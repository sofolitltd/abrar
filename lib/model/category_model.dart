class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  // final List<BrandModel> brands;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    // required this.brands,
  });

  //from json
  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'],
        name: json['name'],
        imageUrl: json['imageUrl'],
        // brands: List<BrandModel>.from(json['brands']),
      );

  // to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        // 'brands': brands,
      };
}

class BrandModel {
  final String id;
  final String name;

  BrandModel({
    required this.id,
    required this.name,
  });
}

//
// List<CategoryModel> categoryList = [
//   CategoryModel(
//     id: '1',
//     name: 'Ator',
//     imageUrl: 'assets/images/img1.png',
//     brands: [
//       BrandModel(id: '1', name: 'Al Naim'),
//     ],
//   ),
//   CategoryModel(
//     id: '2',
//     name: 'Tupi',
//     imageUrl: 'assets/images/img1.png',
//     brands: [
//       BrandModel(id: '1', name: 'Al Naim'),
//     ],
//   ),
//   CategoryModel(
//     id: '3',
//     name: 'Book',
//     imageUrl: 'assets/images/img1.png',
//     brands: [
//       BrandModel(id: '1', name: 'Al Naim'),
//     ],
//   ),
//   CategoryModel(
//     id: '4',
//     name: 'GAs',
//     imageUrl: 'assets/images/img1.png',
//     brands: [
//       BrandModel(id: '1', name: 'Al Naim'),
//     ],
//   ),
//   CategoryModel(
//     id: '5',
//     name: 'Fan',
//     imageUrl: 'assets/images/img1.png',
//     brands: [
//       BrandModel(id: '1', name: 'Al Naim'),
//     ],
//   ),
//   CategoryModel(
//     id: '6',
//     name: 'Light',
//     imageUrl: 'assets/images/img1.png',
//     brands: [
//       BrandModel(id: '1', name: 'Al Naim'),
//     ],
//   ),
//   CategoryModel(
//     id: '7',
//     name: 'Ator',
//     imageUrl: 'assets/images/img1.png',
//     brands: [
//       BrandModel(id: '1', name: 'Al Naim'),
//     ],
//   ),
//   CategoryModel(
//     id: '1',
//     name: 'Tupi',
//     imageUrl: 'assets/images/img1.png',
//     brands: [
//       BrandModel(id: '1', name: 'Al Naim'),
//     ],
//   ),
// ];
